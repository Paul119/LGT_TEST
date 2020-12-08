CREATE TABLE [dbo].[k_modules_types] (
    [id_module_type]   INT           IDENTITY (1, 1) NOT NULL,
    [name_module_type] NVARCHAR (50) NULL,
    CONSTRAINT [PK_k_module_types] PRIMARY KEY CLUSTERED ([id_module_type] ASC)
);

