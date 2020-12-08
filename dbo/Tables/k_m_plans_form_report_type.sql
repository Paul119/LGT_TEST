CREATE TABLE [dbo].[k_m_plans_form_report_type] (
    [id_plan_form_report_type]    INT           IDENTITY (1, 1) NOT NULL,
    [name_plan_form_report_type]  NVARCHAR (50) NULL,
    [group_name_plan_form_report] NVARCHAR (50) NULL,
    CONSTRAINT [PK_k_m_plans_form_report_type] PRIMARY KEY CLUSTERED ([id_plan_form_report_type] ASC)
);

