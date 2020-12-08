CREATE TABLE [dbo].[k_m_workflow_status] (
    [id_status]      INT            NOT NULL,
    [name_status]    NVARCHAR (255) NULL,
    [next_step]      BIT            NULL,
    [increment_step] INT            NULL,
    CONSTRAINT [PK_k_m_workflow_status] PRIMARY KEY CLUSTERED ([id_status] ASC)
);

