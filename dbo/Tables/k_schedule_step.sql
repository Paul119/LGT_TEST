CREATE TABLE [dbo].[k_schedule_step] (
    [id_schedule_step]          INT            IDENTITY (1, 1) NOT NULL,
    [name_schedule_step]        NVARCHAR (100) NULL,
    [type_schedule_step]        INT            NULL,
    [id_schedule_step_sqlagent] INT            NULL,
    [id_schedule]               INT            NULL,
    [parameters]                NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_schedule_step] PRIMARY KEY CLUSTERED ([id_schedule_step] ASC),
    CONSTRAINT [FK_k_schedule_step_k_schedule] FOREIGN KEY ([id_schedule]) REFERENCES [dbo].[k_schedule] ([id_schedule]),
    CONSTRAINT [FK_k_schedule_step_k_schedule_step_type] FOREIGN KEY ([type_schedule_step]) REFERENCES [dbo].[k_schedule_step_type] ([id_schedule_step_type])
);

