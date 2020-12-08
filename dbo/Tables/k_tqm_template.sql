CREATE TABLE [dbo].[k_tqm_template] (
    [id_template]   INT            IDENTITY (1, 1) NOT NULL,
    [name_template] NVARCHAR (200) NULL,
    CONSTRAINT [PK_k_tqm_template] PRIMARY KEY CLUSTERED ([id_template] ASC)
);

