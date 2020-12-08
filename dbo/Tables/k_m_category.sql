CREATE TABLE [dbo].[k_m_category] (
    [id_category]        INT            IDENTITY (1, 1) NOT NULL,
    [name_category]      NVARCHAR (100) NOT NULL,
    [id_parent_category] INT            CONSTRAINT [DF_k_m_category_id_parent_category] DEFAULT ((0)) NULL,
    [type_category]      NVARCHAR (50)  NULL,
    [sort]               INT            NULL,
    CONSTRAINT [PK_k_m_category] PRIMARY KEY CLUSTERED ([id_category] ASC)
);

