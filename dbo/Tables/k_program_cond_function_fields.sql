CREATE TABLE [dbo].[k_program_cond_function_fields] (
    [id_field]         INT            IDENTITY (1, 1) NOT NULL,
    [id_folder]        INT            NOT NULL,
    [name_field]       NVARCHAR (50)  NULL,
    [javascript_field] NVARCHAR (100) NULL,
    [sql_field]        NVARCHAR (100) NULL,
    [color_field]      NVARCHAR (100) NULL,
    [transcript]       BIT            NULL,
    CONSTRAINT [PK_k_program_cond_function_fields] PRIMARY KEY CLUSTERED ([id_field] ASC),
    CONSTRAINT [FK_k_program_cond_function_fields_k_program_cond_function_folders] FOREIGN KEY ([id_folder]) REFERENCES [dbo].[k_program_cond_function_folders] ([id_folder])
);

