CREATE TABLE [dbo].[k_m_olap_scheduler_program_execution_plan] (
    [id_olap_scheduler_program_execution_plan] INT     IDENTITY (1, 1) NOT NULL,
    [id_olap_scheduler]                        INT     NOT NULL,
    [id_program_execution_plan]                INT     NOT NULL,
    [execution_order]                          TINYINT NOT NULL,
    CONSTRAINT [PK_k_m_olap_scheduler_program_execution_plan] PRIMARY KEY CLUSTERED ([id_olap_scheduler_program_execution_plan] ASC),
    CONSTRAINT [FK_k_m_olap_scheduler_program_execution_plan_k_m_olap_scheduler] FOREIGN KEY ([id_olap_scheduler]) REFERENCES [dbo].[k_m_olap_scheduler] ([id]),
    CONSTRAINT [FK_k_m_olap_scheduler_program_execution_plan_k_program_execution_plan] FOREIGN KEY ([id_program_execution_plan]) REFERENCES [dbo].[k_program_execution_plan] ([id_schedule])
);

