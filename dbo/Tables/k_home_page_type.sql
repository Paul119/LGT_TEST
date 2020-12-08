CREATE TABLE [dbo].[k_home_page_type] (
    [id_home_page_type]   INT            IDENTITY (1, 1) NOT NULL,
    [name_home_page_type] NVARCHAR (100) NULL,
    [id_source_tenant]    INT            NULL,
    [id_source]           INT            NULL,
    [id_change_set]       INT            NULL,
    CONSTRAINT [PK_k_home_page_type] PRIMARY KEY CLUSTERED ([id_home_page_type] ASC)
);

