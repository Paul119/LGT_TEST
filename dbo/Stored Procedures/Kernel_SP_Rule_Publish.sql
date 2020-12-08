CREATE PROCEDURE [dbo].[Kernel_SP_Rule_Publish]
 (
  @PAYDETAIL NVARCHAR(100),
  @PUBDETAIL NVARCHAR(100),
  @IDRULE INT,
  @PUBLISHEDUSER INT,
  @IDCOND INT,
  @ARGS dbo.Kernel_ParamList READONLY
 )
 AS
 DECLARE @SQLString NVARCHAR(MAX)
 --DECLARE @PAYDETAIL NVARCHAR(MAX)
 DECLARE @PAYMASTER NVARCHAR(100)
 DECLARE @ParmDefinition NVARCHAR(MAX)
 --DECLARE @PUBDETAIL NVARCHAR(100)
 DECLARE @NAMEDETAILFIELDS NVARCHAR(4000)
 DECLARE @MAXTRANSID INT
 DECLARE @PAYDETAILID INT
 DECLARE @PUBMASTER NVARCHAR(100)
 DECLARE @PUBDETAILID INT
 DECLARE @NAMEMASTERFIELDS NVARCHAR(MAX)
 DECLARE @WHERECOND NVARCHAR(500)

 SELECT @PUBDETAILID = id_table_view
   FROM k_referential_tables_views
  WHERE name_table_view = @PUBDETAIL

 SELECT @PAYDETAILID = id_table_view
   FROM dbo.k_referential_tables_views
  WHERE name_table_view = @PAYDETAIL

 --SET @PUBDETAILID = -1859
 DECLARE @IDMASTERTRANSACTONS NVARCHAR(MAX) = ''
 SET @PUBMASTER = 'k_transaction_master_payment_publication'
 SET @PAYMASTER = 'k_transaction_master_payment'

 --EN SON AKTARILMIS OLAN TRANSACTION ID ALINIR HIC YOKSA 0 GELIR...
 SET @SQLString = N'SELECT @MAXTRANSID_OUT = ISNULL( max(id_trans),0) FROM '+ @PUBDETAIL SET @ParmDefinition = N'@MAXTRANSID_OUT varchar(MAX) OUTPUT'
 EXECUTE sp_executesql @SQLString,@ParmDefinition,@MAXTRANSID_OUT = @MAXTRANSID OUTPUT

 ------DETAIL TABLOSUNDAN HANGI KOLONLARIN ALINACAGI BULUNUR
 SET @NAMEDETAILFIELDS = N''
 SELECT @NAMEDETAILFIELDS = COALESCE(CASE WHEN @NAMEDETAILFIELDS = N'' THEN N'd.['+ ktf.name_field +N']' ELSE @NAMEDETAILFIELDS +N',' + N'd.['+ ktf.name_field +N']' END,N''  )  
   FROM dbo.k_referential_tables_views_fields ktf
  WHERE ktf.id_table_view =  @PAYDETAILID
    AND ktf.name_field in ( SELECT name_field FROM dbo.k_referential_tables_views_fields kpf WHERE kpf.id_table_view = @PUBDETAILID )
    AND constraint_null_field <> 0
 IF @MAXTRANSID = 0
 BEGIN
 SET @WHERECOND = '';
 END
 ELSE
 BEGIN
 SET @WHERECOND = ' WHERE id_trans > '+ CONVERT(NVARCHAR(max), @MAXTRANSID)
 END

 SET @WHERECOND = @WHERECOND + 'AND (id_simulation is null OR id_simulation = 0)'

 ---- DETAIL TABLOSUNUN MAX TRANSACTION ID DEN SONRAKI TUM KAYITLARI CEKILIR
 SET @SQLString = N'INSERT INTO '+ @PUBDETAIL +N' 
 ('+ REPLACE(@NAMEDETAILFIELDS,N'd.',N'') +N', date_publication,id_trans_master,date_trans_payment, amount_trans_payment, date_data_payment, id_trans, id_publication_master, idPayee' + N') ' +N'
 SELECT ' + @NAMEDETAILFIELDS + N', GETUTCDATE() as date_publication, d.id_trans_master, d.date_trans_payment, d.amount_trans_payment, d.date_data_payment, d.id_trans, -1 AS id_publication_master, idPayee' + N'
   FROM ' + @PAYDETAIL  + N' AS d
  INNER JOIN k_transaction_master_payment mas
   ON mas.id_trans_master = d.id_trans_master
   AND mas.id_cond_payment = ' + CAST(@IDCOND AS NVARCHAR(10)) + N'
  ' + @WHERECOND

 EXEC sp_executesql @SQLString

 ------ AKTARILAN KAYITLARIN IDTRANSACTION MASTERLARI BULUNUR...
 SET @SQLString = N' SELECT @IDMASTERTRANSACTONS_OUT =  COALESCE(CASE WHEN @IDMASTERTRANSACTONS_OUT = '''' THEN  CONVERT(NVARCHAR(10),id_trans_master) ELSE @IDMASTERTRANSACTONS_OUT +'',''+ CONVERT(NVARCHAR(10),id_trans_master) END,''''  ) 
 FROM '+@PAYDETAIL + @WHERECOND 
 SET @ParmDefinition = N'@IDMASTERTRANSACTONS_OUT varchar(MAX) OUTPUT'
 SET @SQLString = N'WITH DistinctTransMasterIDs
 AS
 (
 SELECT DISTINCT det.id_trans_master
   FROM ' + @PAYDETAIL + ' det
  INNER JOIN k_transaction_master_payment mas
   ON mas.id_trans_master = det.id_trans_master
   AND mas.id_cond_payment = ' + CAST(@IDCOND AS VARCHAR(10)) + '
  ' + @WHERECOND + '
 )
 SELECT @IDMASTERTRANSACTONS_OUT =  COALESCE(CASE WHEN @IDMASTERTRANSACTONS_OUT = '''' THEN  CONVERT(NVARCHAR(10),id_trans_master) ELSE @IDMASTERTRANSACTONS_OUT +'',''+ CONVERT(NVARCHAR(10),id_trans_master) END,''''  )
   FROM DistinctTransMasterIDs'

 SET @ParmDefinition = N'@IDMASTERTRANSACTONS_OUT varchar(MAX) OUTPUT'

 EXECUTE sp_executesql @SQLString,@ParmDefinition,@IDMASTERTRANSACTONS_OUT = @IDMASTERTRANSACTONS OUTPUT

 ------ BU MASTER IDLERE AIT DATA MATER KAYITLARA AKTARILIR...
 IF @IDMASTERTRANSACTONS <> ''
 BEGIN
  SET @SQLString = 'SET NOCOUNT ON;
  INSERT INTO '+ @PUBMASTER +' 
  (id_trans_master, id_folder_prog_payment, name_folder_prog_payment ,id_prog_payment ,name_prog_payment ,id_cond_payment ,name_cond_payment ,sql_cond_payment ,sql_calc_payment ,id_type_payment ,name_type_payment ,id_category_payment ,name_category_payment ,id_frequency_payment ,name_frequency_payment ,color_payment ,id_version_payment ,name_version_payment ,amount_trans_payment ,unit_trans_payment ,id_status_payment ,name_status_payment ,date_trans_payment ,id_group1_payment ,name_group1_payment ,id_group2_payment ,name_group2_payment)
  SELECT id_trans_master, id_folder_prog_payment, name_folder_prog_payment ,id_prog_payment ,name_prog_payment ,id_cond_payment ,name_cond_payment ,sql_cond_payment ,sql_calc_payment ,id_type_payment ,name_type_payment ,id_category_payment ,name_category_payment ,id_frequency_payment ,name_frequency_payment ,color_payment ,id_version_payment ,name_version_payment ,amount_trans_payment ,unit_trans_payment ,id_status_payment ,name_status_payment ,date_trans_payment ,id_group1_payment ,name_group1_payment ,id_group2_payment ,name_group2_payment
    FROM ' + @PAYMASTER + '
   WHERE id_trans_master IN ( '+ @IDMASTERTRANSACTONS + ' )'

  EXEC sp_executesql @SQLString

  DECLARE @SQL NVARCHAR(MAX)
  SET @SQL= 'SET NOCOUNT ON;
  UPDATE PUBTBL' +
  ' SET PUBTBL.id_publication_master = PUBMST.id_publication_master '+
  'FROM '+@PUBDETAIL + ' PUBTBL ' +
  ' JOIN '+@PAYDETAIL+' PAYTBL ON PAYTBL.id_trans = PUBTBL.id_trans '+
  ' JOIN '+@PUBMASTER+' PUBMST ON PAYTBL.id_trans_master = PUBMST.id_trans_master '

  EXEC sp_executesql @SQL
 END