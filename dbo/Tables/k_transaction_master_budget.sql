﻿CREATE TABLE [dbo].[k_transaction_master_budget] (
    [id_trans_master]       INT            IDENTITY (1, 1) NOT NULL,
    [id_folder_budget]      INT            NULL,
    [name_folder_budget]    NVARCHAR (50)  NULL,
    [id_prog_budget]        INT            NULL,
    [name_prog_budget]      NVARCHAR (100) NULL,
    [id_cond_budget]        INT            NULL,
    [name_cond_budget]      NVARCHAR (100) NULL,
    [sql_cond_budget]       NVARCHAR (MAX) NULL,
    [sql_calc_budget]       NVARCHAR (MAX) NULL,
    [id_type_budget]        INT            NULL,
    [name_type_budget]      NVARCHAR (100) NULL,
    [id_category_budget]    INT            NULL,
    [name_category_budget]  NVARCHAR (100) NULL,
    [id_frequency_budget]   INT            NULL,
    [name_frequency_budget] NVARCHAR (100) NULL,
    [color_budget]          NVARCHAR (50)  NULL,
    [id_version_budget]     INT            CONSTRAINT [DF_k_transaction_master_budget_id_version_budget] DEFAULT ((-2)) NOT NULL,
    [name_version_budget]   NVARCHAR (100) NULL,
    [unit_trans_budget]     NVARCHAR (100) NULL,
    [id_status_budget]      INT            NULL,
    [name_status_budget]    NVARCHAR (100) NULL,
    [date_trans_budget]     DATETIME       NULL,
    [is_deleted]            BIT            CONSTRAINT [DF_k_transaction_master_budget_is_deleted] DEFAULT ((0)) NOT NULL,
    [id_simulation]         INT            CONSTRAINT [DF_k_transaction_master_budget_id_simulation] DEFAULT ((0)) NOT NULL,
    [id_owner]              INT            NULL,
    CONSTRAINT [PK_k_transaction_master_budget] PRIMARY KEY CLUSTERED ([id_trans_master] ASC),
    CONSTRAINT [FK_k_transaction_master_budget_k_versions] FOREIGN KEY ([id_version_budget]) REFERENCES [dbo].[k_versions] ([id_version])
);

