CREATE TABLE [dbo].[k_home_page_item_type] (
    [id_home_page_item_type]   INT            IDENTITY (1, 1) NOT NULL,
    [name_home_page_item_type] NVARCHAR (100) NULL,
    CONSTRAINT [PK_k_home_page_item_type] PRIMARY KEY CLUSTERED ([id_home_page_item_type] ASC)
);

