
CREATE PROCEDURE [dbo].[sp_client_std_synchronize]																		
		 (																		
			@table_name nvarchar(255)																	
			, @type_table_view nvarchar(50)																	
			, @type_data int																	
			, @id_table_view int = NULL	OUTPUT 																
		 )																		
		 AS																		
		SET XACT_ABORT ON;																		
					BEGIN TRANSACTION																	
																		
					DECLARE @constraint_null bit																		
					DECLARE @constraint VARCHAR(255)																		
					DECLARE @column_name NVARCHAR(255)																		
					DECLARE @type VARCHAR(255)																		
					DECLARE @longueur VARCHAR(255)																		
					DECLARE @temp VARCHAR(255)																		
					DECLARE @identity int																		
					DECLARE @order_field int																		
					DECLARE @IsAdd bit															
					DECLARE @id_field int															
																		
					set  @IsAdd=(SELECT count(1) FROM k_referential_tables_views WHERE UPPER(name_table_view) = UPPER(@table_name))																		
																		
					IF (@IsAdd='False')															
					BEGIN															
						INSERT INTO dbo.k_referential_tables_views (name_table_view,type_table_view,type_data,is_kernel,id_object_security_table_view) 														
						VALUES (@table_name,@type_table_view,@type_data,0,NULL)														
						SET @identity=@@identity														
																		
						SET @id_table_view=(SELECT id_table_view FROM k_referential_tables_views WHERE UPPER(name_table_view) = UPPER(@table_name))														
																		
					END															
					ELSE															
					BEGIN															
						SET @identity=(SELECT id_table_view FROM k_referential_tables_views WHERE name_table_view = @table_name)														
						UPDATE dbo.k_referential_tables_views SET @type_table_view=@type_table_view  ,@type_data=@type_data														
						WHERE  name_table_view = @table_name														
																		
						SET @id_table_view=@identity														
					END															
																		
					DECLARE Customer CURSOR FOR																		
																		
					SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS																		
					WHERE table_name=@table_name																		
																		
					OPEN Customer																		
					FETCH Customer INTO @column_name																		
																		
					WHILE @@Fetch_Status = 0																		
					BEGIN																		
																		
						SET @constraint=null																	
																		
						--type																	
						SET @type=																	
						(SELECT data_type FROM INFORMATION_SCHEMA.COLUMNS																	
						WHERE table_name=@table_name AND column_name=@column_name)																	
																		
						--longueur																	
																		
						SET @longueur=																	
						(SELECT CASE																	
							WHEN (@type='decimal' OR @type='numeric')																
							THEN  CAST(numeric_precision as VARCHAR)																
							+ '.' + CAST(numeric_scale as VARCHAR)																
																		
							WHEN (@type LIKE '%char%' OR @type LIKE '%binary%' )																
							THEN CAST(character_maximum_length as VARCHAR)																
						END																	
						FROM INFORMATION_SCHEMA.COLUMNS																	
						--WHERE table_name=@table_name AND column_name=@column_name																	
						WHERE table_name=@table_name AND column_name=@column_name																	
						)																	
																		
						--contrainte nulle:																	
						 SET @constraint_null=																	
						(SELECT CASE																	
							WHEN is_nullable='YES' THEN 1 ELSE 0 END																
																		
						FROM INFORMATION_SCHEMA.COLUMNS																	
						WHERE table_name=@table_name AND column_name=@column_name																	
						)																	
																		
						--order																	
						 SET @order_field=																	
						(SELECT ordinal_position																	
						FROM INFORMATION_SCHEMA.COLUMNS																	
						WHERE table_name=@table_name AND column_name=@column_name																	
						)																	
																		
						--contraintes:																	
																		
						--collation																	
																		
						SET @temp=																	
						(SELECT collation_name FROM INFORMATION_SCHEMA.COLUMNS																	
						WHERE table_name=@table_name AND column_name=@column_name)																	
																		
						IF (@temp IS NOT NULL)																	
						BEGIN																	
							SET @constraint= 'COLLATE' + char(32) + @temp + char(32)																
						END																	
																		
					--clé primaire																		
																		
						SET @temp=																	
						(																	
						SELECT constraint_name FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE K																	
						INNER JOIN																	
						sys.key_constraints C ON K.constraint_name = C.name																	
						WHERE K.table_name=@table_name AND K.column_name=@column_name																	
						AND C.type='PK'																	
						)																	
																		
						IF  @temp IS NOT NULL																	
						BEGIN																	
							IF @constraint IS NOT NULL																
							BEGIN																
								SET @constraint = @constraint + 'PRIMARY KEY ' + char(32)															
							END																
							ELSE																
								BEGIN															
								SET @constraint =  'PRIMARY KEY ' + char(32)															
							END																
						END																	
																		
					--auto_increment																		
																		
						SET @temp=																	
						(																	
						SELECT ' IDENTITY('+CAST(seed_value as VARCHAR)+',' +																	
						CAST(increment_value AS VARCHAR) +')' from sys.all_objects O																	
						INNER JOIN																	
						sys.identity_columns I ON O.object_id = I.object_id																	
																		
						WHERE O.name=@table_name AND I.name=@column_name																	
						)																	
																		
						IF  @temp IS NOT NULL																	
						BEGIN																	
							IF @constraint IS NOT NULL																
							BEGIN																
								SET @constraint = @constraint + @temp + char(32)															
							END																
							ELSE																
								BEGIN															
								SET @constraint =  @temp + char(32)															
							END																
						END																	
																		
						--UNIQUE																	
																		
						SET @temp=																	
						(																	
						SELECT top 1 constraint_name FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE K																	
						INNER JOIN																	
						sys.key_constraints C ON K.constraint_name = C.name																	
						WHERE K.table_name=@table_name AND K.column_name=@column_name																	
						AND C.type='UQ'																	
						)																	
																		
						IF  @temp IS NOT NULL																	
						BEGIN																	
							IF @constraint IS NOT NULL																
							BEGIN																
								SET @constraint = @constraint + 'UNIQUE' + char(32)															
							END																
							ELSE																
								BEGIN															
								SET @constraint =  'UNIQUE' + char(32)															
							END																
						END																	
																		
						--DEFAULT																	
						SET @temp=(																	
						SELECT REPLACE(REPLACE(column_default,'(',''),')','') FROM INFORMATION_SCHEMA.COLUMNS																	
						WHERE table_name=@table_name AND column_name=@column_name)																	
																		
						IF @temp IS NOT NULL																	
						BEGIN																	
						IF @constraint IS NOT NULL																	
							BEGIN																
								SET @constraint = @constraint +    'DEFAULT ' + REPLACE(@temp,'''','') +char(32)															
							END																
							ELSE																
							BEGIN															
							   SET @constraint = 'DEFAULT ' + REPLACE(@temp,'''','') +char(32)															
							END																
																		
																		
						END																	
																		
						--CHECK																	
																		
						SET @temp=																	
						(																	
						SELECT  CHECK_CLAUSE FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE S																		
						INNER JOIN INFORMATION_SCHEMA.CHECK_CONSTRAINTS  C																	
						ON C.CONSTRAINT_NAME=S.CONSTRAINT_NAME																	
						WHERE COLUMN_NAME=@column_name AND table_name = @table_name																	
						)																	
																		
						IF  @temp IS NOT NULL																	
						BEGIN																	
							IF @constraint IS NOT NULL																
							BEGIN																
								SET @constraint = @constraint + 'CHECK ' + @temp															
							END																
							ELSE																
								BEGIN															
								SET @constraint =  'CHECK ' + @temp															
							END																
						END																	
																		
						IF (@constraint IS NOT NULL) --suppression du premier et dernier espace																	
						BEGIN																	
						SET @constraint = substring(@constraint,1,LEN(@constraint))																	
						END																	
																		
						IF (@IsAdd = 'True')														
						BEGIN														
							SET @id_field=(SELECT id_field from  k_referential_tables_views_fields WHERE id_table_view = @identity													
							and name_field = @column_name  )													
						END														
																		
						IF (@id_field is   null)														
						BEGIN														
							INSERT INTO k_referential_tables_views_fields													
							(id_table_view,name_field,type_field,length_field,constraint_null_field,													
							constraint_field,order_field)													
							SELECT  @identity,@column_name name_field, @type type_field, @longueur length_field,													
									@constraint_null constraint_null_field, @constraint constraint_field,@order_field order_field											
						END														
						ELSE														
						BEGIN														
							UPDATE  k_referential_tables_views_fields													
							SET type_field=@type,													
								length_field=@longueur,												
									constraint_null_field=@constraint_null,											
									constraint_field=@constraint,											
									order_field=@order_field											
								WHERE  id_table_view = @identity and name_field = @column_name												
						END														
																		
					FETCH Customer INTO @column_name																		
																		
					END																		
																		
					CLOSE Customer																		
					DEALLOCATE Customer;																		
																		
					delete from  k_referential_tables_views_fields where id_field in															
					(															
																		
					SELECT id_field FROM															
					k_referential_tables_views_fields where id_table_view=@identity															
					and															
					(															
						select 1 from INFORMATION_SCHEMA.COLUMNS														
						where table_name=@table_name AND column_name = name_field														
					 ) is  null															
					)															
																		
				  COMMIT;																		
				  SET XACT_ABORT OFF;