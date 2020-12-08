CREATE TABLE [dbo].[k_schedule_step_type] (
    [id_schedule_step_type]    INT            IDENTITY (1, 1) NOT NULL,
    [name_schedule_step_type]  NVARCHAR (100) NULL,
    [visible]                  BIT            CONSTRAINT [DF_k_schedule_step_type_visible] DEFAULT ((1)) NOT NULL,
    [order_schedule_step_type] INT            NULL,
    CONSTRAINT [PK_k_schedule_step_type] PRIMARY KEY CLUSTERED ([id_schedule_step_type] ASC)
);

