CREATE TABLE [dbo].[k_content_html_type] (
    [id_type]   INT           IDENTITY (1, 1) NOT NULL,
    [name_type] NVARCHAR (64) NOT NULL,
    CONSTRAINT [PK_content_html_type] PRIMARY KEY CLUSTERED ([id_type] ASC)
);

