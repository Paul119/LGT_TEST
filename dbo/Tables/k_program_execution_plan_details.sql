CREATE TABLE [dbo].[k_program_execution_plan_details] (
    [id_detail]        INT IDENTITY (1, 1) NOT NULL,
    [id_schedule]      INT NULL,
    [order_schedule]   INT NULL,
    [id_prog]          INT NULL,
    [id_cond]          INT NULL,
    [id_version]       INT NULL,
    [id_source_tenant] INT NULL,
    [id_source]        INT NULL,
    [id_change_set]    INT NULL,
    CONSTRAINT [PK_k_program_execution_plan_details] PRIMARY KEY CLUSTERED ([id_detail] ASC),
    CONSTRAINT [FK_k_program_schedule_details_k_program] FOREIGN KEY ([id_prog]) REFERENCES [dbo].[k_program] ([id_prog]),
    CONSTRAINT [FK_k_program_schedule_details_k_program_cond] FOREIGN KEY ([id_cond]) REFERENCES [dbo].[k_program_cond] ([id_cond]),
    CONSTRAINT [FK_k_program_schedule_details_k_program_schedule] FOREIGN KEY ([id_schedule]) REFERENCES [dbo].[k_program_execution_plan] ([id_schedule])
);

