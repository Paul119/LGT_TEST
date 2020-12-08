CREATE TABLE [dbo].[k_m_plan_status] (
    [id_plan_status]   INT            IDENTITY (1, 1) NOT NULL,
    [name_plan_status] NVARCHAR (200) NOT NULL,
    [is_visible]       BIT            NOT NULL,
    [is_editable]      BIT            NOT NULL,
    [sort_order]       INT            NOT NULL,
    [is_default]       BIT            NOT NULL,
    CONSTRAINT [PK_k_m_plan_status] PRIMARY KEY CLUSTERED ([id_plan_status] ASC)
);

