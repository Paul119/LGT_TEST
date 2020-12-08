CREATE TABLE [dbo].[k_m_workflow] (
    [id_workflow]      INT            IDENTITY (1, 1) NOT NULL,
    [name_workflow]    NVARCHAR (255) NOT NULL,
    [id_source_tenant] INT            NULL,
    [id_source]        INT            NULL,
    [id_change_set]    INT            NULL,
    CONSTRAINT [PK_k_m_workflow] PRIMARY KEY CLUSTERED ([id_workflow] ASC)
);

