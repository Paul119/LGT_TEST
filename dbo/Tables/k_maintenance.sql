CREATE TABLE [dbo].[k_maintenance] (
    [id_maintenance]        INT            IDENTITY (1, 1) NOT NULL,
    [id_schedule_step]      INT            NULL,
    [estimated_minutes]     INT            NULL,
    [start]                 DATETIME       NULL,
    [end]                   DATETIME       NULL,
    [next_start]            DATETIME       NULL,
    [next_warning_start]    DATETIME       NULL,
    [terminate_on_complete] BIT            CONSTRAINT [DF_k_maintenance_terminate_on_complete] DEFAULT ((0)) NOT NULL,
    [earlywarning_minutes]  INT            NULL,
    [description]           NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_maintenance] PRIMARY KEY CLUSTERED ([id_maintenance] ASC),
    CONSTRAINT [FK_k_maintenance_k_schedule_step] FOREIGN KEY ([id_schedule_step]) REFERENCES [dbo].[k_schedule_step] ([id_schedule_step])
);

