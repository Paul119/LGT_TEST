﻿CREATE TABLE [dbo].[nc_Task] (
    [id]                     INT            IDENTITY (1, 1) NOT NULL,
    [beginDate]              DATETIME       NULL,
    [endDate]                DATETIME       NULL,
    [title]                  NVARCHAR (100) NULL,
    [definition]             NVARCHAR (MAX) NULL,
    [receiver]               NVARCHAR (MAX) NULL,
    [isMailActivated]        BIT            NULL,
    [idTrigger]              INT            NULL,
    [idTriggerEvent]         INT            NULL,
    [idRule]                 INT            NULL,
    [idProcess]              INT            NULL,
    [idWfStep]               INT            NULL,
    [idTransferRequest]      INT            NULL,
    [isGrouped]              BIT            NULL,
    [allowedTime]            INT            NULL,
    [warnTime]               INT            NULL,
    [criticTime]             INT            NULL,
    [idTimeStep]             INT            NULL,
    [idOwner]                INT            NULL,
    [processStartDateFilter] DATETIME       NULL,
    [processEndDateFilter]   DATETIME       NULL,
    [mailPriority]           SMALLINT       NULL,
    [idFolder]               INT            NULL,
    [definition_original]    NVARCHAR (MAX) NULL,
    [use_translate]          BIT            CONSTRAINT [DF_nc_Task_use_translate] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_nc_TaskNotification] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_nc_Task_k_m_plans] FOREIGN KEY ([idProcess]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_nc_Task_k_m_workflow_step] FOREIGN KEY ([idWfStep]) REFERENCES [dbo].[k_m_workflow_step] ([id_wflstep]),
    CONSTRAINT [FK_nc_Task_k_users] FOREIGN KEY ([idOwner]) REFERENCES [dbo].[k_users] ([id_user]),
    CONSTRAINT [FK_nc_Task_nc_Folder] FOREIGN KEY ([idFolder]) REFERENCES [dbo].[nc_Folder] ([id_folder]),
    CONSTRAINT [FK_nc_Task_nc_TimeStep] FOREIGN KEY ([idTimeStep]) REFERENCES [dbo].[nc_TimeStep] ([id]),
    CONSTRAINT [FK_nc_Task_nc_Trigger] FOREIGN KEY ([idTrigger]) REFERENCES [dbo].[nc_Trigger] ([id]),
    CONSTRAINT [FK_nc_Task_nc_TriggerEvent] FOREIGN KEY ([idTriggerEvent]) REFERENCES [dbo].[nc_TriggerEvent] ([id])
);

