CREATE TABLE [dbo].[k_m_plans_payees_steps_workflow_bulkvalidate_master] (
    [id]                     INT      IDENTITY (1, 1) NOT NULL,
    [id_user]                INT      NOT NULL,
    [id_profile]             INT      NOT NULL,
    [id_plan]                INT      NOT NULL,
    [id_tree]                INT      NOT NULL,
    [is_validation]          BIT      NOT NULL,
    [start_time]             DATETIME NOT NULL,
    [end_time]               DATETIME NULL,
    [total_payees]           INT      NOT NULL,
    [successful_validations] INT      NULL,
    [denied_validations]     INT      NULL,
    [invalid_validations]    INT      NULL,
    CONSTRAINT [PK_k_m_plans_payees_steps_workflow_bulkvalidate_master] PRIMARY KEY CLUSTERED ([id] ASC)
);

