CREATE TABLE [dbo].[k_program_cond_function_folders] (
    [id_folder]   INT            IDENTITY (1, 1) NOT NULL,
    [name_folder] NVARCHAR (100) NULL,
    CONSTRAINT [PK_k_program_cond_function_folders] PRIMARY KEY CLUSTERED ([id_folder] ASC)
);

