CREATE TABLE [dbo].[cm_rule_executionresult_detail] (
    [id_execution_result_detail]               INT            IDENTITY (1, 1) NOT NULL,
    [idExecutionResult]                        INT            NULL,
    [id_rule]                                  INT            NULL,
    [id_cond]                                  INT            NOT NULL,
    [id_simulation]                            INT            NULL,
    [id_process]                               INT            NULL,
    [id_program_schedule]                      INT            NULL,
    [id_specific_pop]                          NVARCHAR (MAX) NULL,
    [id_specific_payee]                        INT            NULL,
    [id_olap_scheduler_program_execution_plan] INT            NULL,
    [affected_rows]                            INT            NULL,
    [start_date]                               DATETIME       NULL,
    [end_date]                                 DATETIME       NULL,
    [execution_status]                         NVARCHAR (MAX) NULL,
    [execution_error]                          NVARCHAR (MAX) NULL,
    [executor_user_id]                         INT            NULL,
    [executor_user_profile_id]                 INT            NULL,
    [execution_query]                          NVARCHAR (MAX) NULL,
    [transaction_master_id]                    INT            NULL,
    CONSTRAINT [PK_cm_rule_executionresult_detail] PRIMARY KEY CLUSTERED ([id_execution_result_detail] ASC),
    CONSTRAINT [FK_cm_rule_executionresult_detail_cm_rule_executionresult] FOREIGN KEY ([idExecutionResult]) REFERENCES [dbo].[cm_rule_executionresult] ([idExecutionResult])
);

