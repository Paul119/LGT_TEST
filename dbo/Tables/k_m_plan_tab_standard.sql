CREATE TABLE [dbo].[k_m_plan_tab_standard] (
    [id_plan_tab_standard]   INT            IDENTITY (1, 1) NOT NULL,
    [name_plan_tab_standard] NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_k_m_plan_tab_standard] PRIMARY KEY CLUSTERED ([id_plan_tab_standard] ASC)
);

