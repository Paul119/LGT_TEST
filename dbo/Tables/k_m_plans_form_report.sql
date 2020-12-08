CREATE TABLE [dbo].[k_m_plans_form_report] (
    [id]                       INT              IDENTITY (1, 1) NOT NULL,
    [id_plan]                  INT              NULL,
    [id_report]                INT              NULL,
    [name_form]                NVARCHAR (100)   NULL,
    [id_plan_form_report_type] INT              NULL,
    [id_source_tenant]         INT              NULL,
    [id_source]                INT              NULL,
    [id_change_set]            INT              NULL,
    [show_by_default]          BIT              NULL,
    [sort_order]               INT              NULL,
    [uid_object_relation]      UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_k_m_plans_form_report] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_m_plans_form_report_k_m_plans_form_report_type] FOREIGN KEY ([id_plan_form_report_type]) REFERENCES [dbo].[k_m_plans_form_report_type] ([id_plan_form_report_type]),
    CONSTRAINT [FK_k_m_plans_form_report_k_m_plans1] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan])
);

