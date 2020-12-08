﻿CREATE TABLE [dbo].[k_users_parameters] (
    [id]                          INT              IDENTITY (1, 1) NOT NULL,
    [defaultProfileId]            INT              NOT NULL,
    [cultureParamsUsed]           BIT              NOT NULL,
    [thousandSeparator]           CHAR (1)         NULL,
    [decimalSeparator]            CHAR (1)         NULL,
    [datetimeFormat]              NVARCHAR (50)    NULL,
    [dateFormat]                  NVARCHAR (50)    NULL,
    [hideUserPanelAlways]         BIT              NOT NULL,
    [numberOfDaysBoxItems]        INT              NOT NULL,
    [dynamicNotification]         BIT              NOT NULL,
    [autoLoadLastSelectedProcess] BIT              CONSTRAINT [DF_k_users_parameters_autoLoadLastSelectedProcess] DEFAULT ((1)) NOT NULL,
    [lastSelectedProcess]         INT              NULL,
    [autoLoadCurrentPeriod]       BIT              CONSTRAINT [DF_k_users_parameters_autoLoadCurrentPeriod] DEFAULT ((1)) NULL,
    [culture]                     NVARCHAR (50)    NULL,
    [defaultTree]                 INT              NULL,
    [messagePosition]             NVARCHAR (5)     NULL,
    [cultureUsedInReports]        BIT              CONSTRAINT [DF_k_users_parameters_cultureUsedInReports] DEFAULT ((0)) NOT NULL,
    [defaultAppraisal]            INT              CONSTRAINT [DF_k_users_parameters_defaultAppraisal] DEFAULT ((-1)) NOT NULL,
    [enableAccessibilityMode]     BIT              CONSTRAINT [DF_k_users_parameters_enableAccessibilityMode] DEFAULT ((0)) NULL,
    [idCustomLayout]              UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_k_users_parameters] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_users_parameters_k_m_plans_appraisal] FOREIGN KEY ([defaultAppraisal]) REFERENCES [dbo].[k_m_plans_appraisal] ([id_appraisal])
);

