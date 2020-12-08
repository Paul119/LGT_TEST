CREATE TABLE [dbo].[k_program_cond_folders] (
    [id_folder]        INT           IDENTITY (1, 1) NOT NULL,
    [id_universe]      INT           NOT NULL,
    [name_folder]      NVARCHAR (50) NULL,
    [id_parent_folder] INT           NULL,
    [id_source_tenant] INT           NULL,
    [id_source]        INT           NULL,
    [id_change_set]    INT           NULL,
    CONSTRAINT [PK_k_condition_folder] PRIMARY KEY CLUSTERED ([id_folder] ASC),
    CONSTRAINT [FK_k_program_cond_folders_k_program_cond_folders] FOREIGN KEY ([id_parent_folder]) REFERENCES [dbo].[k_program_cond_folders] ([id_folder]),
    CONSTRAINT [FK_k_program_cond_folders_k_program_cond_universes] FOREIGN KEY ([id_universe]) REFERENCES [dbo].[k_program_cond_universes] ([id_universe])
);

