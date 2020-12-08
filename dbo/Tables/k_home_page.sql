CREATE TABLE [dbo].[k_home_page] (
    [id_home_page]      INT            IDENTITY (1, 1) NOT NULL,
    [display_name]      NVARCHAR (100) NULL,
    [description]       NVARCHAR (MAX) NULL,
    [id_home_page_type] INT            NOT NULL,
    [create_date]       DATETIME       NULL,
    [modify_date]       DATETIME       NULL,
    [id_owner]          INT            NULL,
    [id_source_tenant]  INT            NULL,
    [id_source]         INT            NULL,
    [id_change_set]     INT            NULL,
    CONSTRAINT [PK_k_home_page] PRIMARY KEY CLUSTERED ([id_home_page] ASC),
    CONSTRAINT [FK_k_home_page_k_home_page_type] FOREIGN KEY ([id_home_page_type]) REFERENCES [dbo].[k_home_page_type] ([id_home_page_type]),
    CONSTRAINT [FK_k_home_page_k_users] FOREIGN KEY ([id_owner]) REFERENCES [dbo].[k_users] ([id_user])
);

