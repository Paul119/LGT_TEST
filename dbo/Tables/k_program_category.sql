CREATE TABLE [dbo].[k_program_category] (
    [id_category]       INT             IDENTITY (1, 1) NOT NULL,
    [name_category]     NVARCHAR (50)   NOT NULL,
    [comments_category] NVARCHAR (2000) NULL,
    [id_source_tenant]  INT             NULL,
    [id_source]         INT             NULL,
    [id_change_set]     INT             NULL,
    CONSTRAINT [PK_k_program_category] PRIMARY KEY CLUSTERED ([id_category] ASC)
);

