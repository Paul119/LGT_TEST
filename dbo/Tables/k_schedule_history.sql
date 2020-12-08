CREATE TABLE [dbo].[k_schedule_history] (
    [InstanceId]                 INT            IDENTITY (1, 1) NOT NULL,
    [k_schedule_id]              INT            NULL,
    [k_schedule_step_id]         INT            NULL,
    [k_schedule_history_type_id] INT            NOT NULL,
    [JobName]                    NVARCHAR (512) NOT NULL,
    [StepName]                   NVARCHAR (512) NOT NULL,
    [Status]                     INT            NOT NULL,
    [Message]                    NVARCHAR (512) NULL,
    [RunDateTime]                DATETIME       NOT NULL,
    [RunDuration]                TIME (7)       NULL,
    [Enabled]                    BIT            NULL,
    [DetailedMessage]            NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_schedule_history] PRIMARY KEY CLUSTERED ([InstanceId] ASC),
    CONSTRAINT [FK_k_schedule_history_k_schedule] FOREIGN KEY ([k_schedule_id]) REFERENCES [dbo].[k_schedule] ([id_schedule]),
    CONSTRAINT [FK_k_schedule_history_k_schedule_history_type] FOREIGN KEY ([k_schedule_history_type_id]) REFERENCES [dbo].[k_schedule_history_type] ([Id]),
    CONSTRAINT [FK_k_schedule_history_k_schedule_step] FOREIGN KEY ([k_schedule_step_id]) REFERENCES [dbo].[k_schedule_step] ([id_schedule_step])
);

