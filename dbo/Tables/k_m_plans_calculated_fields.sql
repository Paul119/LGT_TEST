CREATE TABLE [dbo].[k_m_plans_calculated_fields] (
    [id]                INT            IDENTITY (1, 1) NOT NULL,
    [id_plan]           INT            NULL,
    [id_ind]            INT            NULL,
    [id_field]          INT            NULL,
    [formula]           NVARCHAR (MAX) NULL,
    [used_fields]       NVARCHAR (MAX) NULL,
    [used_info_columns] NVARCHAR (MAX) NULL,
    [id_user]           INT            NULL,
    [date_creation]     DATETIME       NULL,
    [id_user_update]    INT            NULL,
    [date_update]       DATETIME       NULL,
    [InUse]             BIT            NULL,
    [id_source_tenant]  INT            NULL,
    [id_source]         INT            NULL,
    [id_change_set]     INT            NULL,
    CONSTRAINT [PK_k_m_plans_calculated_fields] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_m_plans_calculated_fields_k_m_fields] FOREIGN KEY ([id_field]) REFERENCES [dbo].[k_m_fields] ([id_field]),
    CONSTRAINT [FK_k_m_plans_calculated_fields_k_m_indicators] FOREIGN KEY ([id_ind]) REFERENCES [dbo].[k_m_indicators] ([id_ind]),
    CONSTRAINT [FK_k_m_plans_calculated_fields_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan])
);

