CREATE TABLE [dbo].[cm_process_execution_plan] (
    [id_process_execution_plan] INT IDENTITY (1, 1) NOT NULL,
    [id_process]                INT NULL,
    [id_execution_plan]         INT NULL,
    [id_source_tenant]          INT NULL,
    [id_source]                 INT NULL,
    [id_change_set]             INT NULL,
    CONSTRAINT [PK_cm_process_execution_plan] PRIMARY KEY CLUSTERED ([id_process_execution_plan] ASC),
    CONSTRAINT [FK_cm_process_execution_plan_k_m_plans] FOREIGN KEY ([id_process]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_cm_process_execution_plan_k_program_execution_plan] FOREIGN KEY ([id_execution_plan]) REFERENCES [dbo].[k_program_execution_plan] ([id_schedule])
);

