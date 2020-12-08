CREATE TABLE [dbo].[k_content_html] (
    [item_id]              INT            NOT NULL,
    [id_content_html_type] INT            NOT NULL,
    [culture]              NVARCHAR (10)  NOT NULL,
    [value]                NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([item_id] ASC, [id_content_html_type] ASC, [culture] ASC)
);

