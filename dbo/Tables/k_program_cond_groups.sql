CREATE TABLE [dbo].[k_program_cond_groups] (
    [id_group]       INT           IDENTITY (1, 1) NOT NULL,
    [name_group]     NVARCHAR (50) NULL,
    [type_group]     NVARCHAR (50) NULL,
    [language_group] CHAR (5)      NULL,
    [display_group]  CHAR (1)      CONSTRAINT [DF_k_program_cond_groups_display_group] DEFAULT ('T') NULL,
    CONSTRAINT [PK_k_program_cond_group] PRIMARY KEY CLUSTERED ([id_group] ASC)
);

