CREATE TABLE [dbo].[k_m_plans_folders] (
    [id_folder]          INT            IDENTITY (1, 1) NOT NULL,
    [id_parent_folder]   INT            NULL,
    [name_folder]        NVARCHAR (100) NULL,
    [is_public]          BIT            NULL,
    [visibility]         BIT            NULL,
    [id_owner]           INT            NULL,
    [date_create_folder] DATETIME       NULL,
    [id_user_update]     INT            NULL,
    [date_update_folder] DATETIME       NULL,
    [id_source_tenant]   INT            NULL,
    [id_source]          INT            NULL,
    [id_change_set]      INT            NULL,
    CONSTRAINT [PK_k_m_plans_folders] PRIMARY KEY CLUSTERED ([id_folder] ASC),
    CONSTRAINT [FK_k_m_plans_folders_k_m_plans_folders] FOREIGN KEY ([id_parent_folder]) REFERENCES [dbo].[k_m_plans_folders] ([id_folder])
);

