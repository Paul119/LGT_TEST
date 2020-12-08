﻿CREATE TABLE [dbo].[nc_Report] (
    [id]                         INT            IDENTITY (1, 1) NOT NULL,
    [beginDate]                  DATETIME       NULL,
    [endDate]                    DATETIME       NULL,
    [title]                      NVARCHAR (100) NULL,
    [definition]                 NVARCHAR (MAX) NULL,
    [receiver]                   NVARCHAR (MAX) NULL,
    [isMailActivated]            BIT            NULL,
    [isImmediate]                BIT            NULL,
    [isPersonal]                 BIT            NOT NULL,
    [idReport]                   INT            NULL,
    [idOwner]                    INT            NULL,
    [idDetail]                   INT            NULL,
    [idType]                     TINYINT        CONSTRAINT [DF_nc_Report_idType] DEFAULT ((1)) NOT NULL,
    [idFolder]                   INT            NULL,
    [id_source_tenant]           INT            NULL,
    [id_source]                  INT            NULL,
    [id_change_set]              INT            NULL,
    [file_template_name]         NVARCHAR (200) NULL,
    [zip_enabled]                BIT            CONSTRAINT [DF_nc_Report_zip_enabled] DEFAULT ((0)) NOT NULL,
    [zip_pdf_generation_enabled] BIT            CONSTRAINT [DF_nc_Report_zip_pdf_generation_enabled] DEFAULT ((0)) NOT NULL,
    [zip_reciever]               NVARCHAR (MAX) NULL,
    [definition_original]        NVARCHAR (MAX) NULL,
    [use_translate]              BIT            CONSTRAINT [DF_nc_Report_use_translate] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_nc_ReportNotification] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_nc_Report_k_reports] FOREIGN KEY ([idReport]) REFERENCES [dbo].[k_reports] ([id_report]),
    CONSTRAINT [FK_nc_Report_k_users] FOREIGN KEY ([idOwner]) REFERENCES [dbo].[k_users] ([id_user]),
    CONSTRAINT [FK_nc_Report_nc_Folder] FOREIGN KEY ([idFolder]) REFERENCES [dbo].[nc_Folder] ([id_folder]),
    CONSTRAINT [FK_nc_Report_nc_subscription] FOREIGN KEY ([idDetail]) REFERENCES [dbo].[nc_subscription] ([id])
);

