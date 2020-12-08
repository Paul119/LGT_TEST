CREATE TABLE [dbo].[k_m_plan_display_tab] (
    [id_plan_display_tab]  INT IDENTITY (1, 1) NOT NULL,
    [id_plan_display]      INT NOT NULL,
    [id_plan_tab_standard] INT NULL,
    [id_plan_form_report]  INT NULL,
    [display_order]        INT NOT NULL,
    [id_source_tenant]     INT NULL,
    [id_source]            INT NULL,
    [id_change_set]        INT NULL,
    CONSTRAINT [PK_k_m_plan_display_tab] PRIMARY KEY CLUSTERED ([id_plan_display_tab] ASC),
    CONSTRAINT [CK_k_m_plan_display_tab_tab_kernel_form_report] CHECK ([id_plan_tab_standard] IS NOT NULL AND [id_plan_form_report] IS NULL OR [id_plan_tab_standard] IS NULL AND [id_plan_form_report] IS NOT NULL),
    CONSTRAINT [FK_k_m_plan_display_tab_k_m_plan_display] FOREIGN KEY ([id_plan_display]) REFERENCES [dbo].[k_m_plan_display] ([id_plan_display]),
    CONSTRAINT [FK_k_m_plan_display_tab_k_m_plan_tab_standard] FOREIGN KEY ([id_plan_tab_standard]) REFERENCES [dbo].[k_m_plan_tab_standard] ([id_plan_tab_standard]),
    CONSTRAINT [FK_k_m_plan_display_tab_k_m_plans_form_report] FOREIGN KEY ([id_plan_form_report]) REFERENCES [dbo].[k_m_plans_form_report] ([id])
);

