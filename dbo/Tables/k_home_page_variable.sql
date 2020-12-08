CREATE TABLE [dbo].[k_home_page_variable] (
    [id_home_page_variable]   INT            IDENTITY (1, 1) NOT NULL,
    [name_home_page_variable] NVARCHAR (100) NULL,
    CONSTRAINT [PK_k_home_page_variable] PRIMARY KEY CLUSTERED ([id_home_page_variable] ASC)
);

