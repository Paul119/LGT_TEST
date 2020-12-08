CREATE TABLE [dbo].[k_program_cond_fields_values] (
    [id]       INT            IDENTITY (1, 1) NOT NULL,
    [id_cond]  INT            NOT NULL,
    [id_field] INT            NOT NULL,
    [value]    NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_program_cond_fields_values] PRIMARY KEY CLUSTERED ([id] ASC)
);

