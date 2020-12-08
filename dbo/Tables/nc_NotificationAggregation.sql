CREATE TABLE [dbo].[nc_NotificationAggregation] (
    [id]                               INT IDENTITY (1, 1) NOT NULL,
    [idNotification]                   INT NOT NULL,
    [idPlansPayeesStepsWorkflowXhisto] INT NULL,
    [idCurrentStep]                    INT NULL,
    [idNextStep]                       INT NULL,
    CONSTRAINT [PK_nc_NotificationAggregation] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_nc_NotificationAggregation_k_m_plans_payees_steps_workflow_xhisto] FOREIGN KEY ([idPlansPayeesStepsWorkflowXhisto]) REFERENCES [dbo].[k_m_plans_payees_steps_workflow_xhisto] ([id]),
    CONSTRAINT [FK_nc_NotificationAggregation_nc_notification] FOREIGN KEY ([idNotification]) REFERENCES [dbo].[nc_Notification] ([id])
);

