﻿CREATE TABLE [dbo].[k_transaction_master_payment_publication] (
    [id_publication_master]    INT             IDENTITY (1, 1) NOT NULL,
    [id_trans_master]          INT             NOT NULL,
    [id_folder_prog_payment]   INT             NULL,
    [name_folder_prog_payment] NVARCHAR (50)   NULL,
    [id_prog_payment]          INT             NULL,
    [name_prog_payment]        NVARCHAR (50)   NULL,
    [id_cond_payment]          INT             NULL,
    [name_cond_payment]        NVARCHAR (100)  NULL,
    [sql_cond_payment]         NVARCHAR (MAX)  NULL,
    [sql_calc_payment]         NVARCHAR (MAX)  NULL,
    [id_type_payment]          INT             NULL,
    [name_type_payment]        NVARCHAR (100)  NULL,
    [id_category_payment]      INT             NULL,
    [name_category_payment]    NVARCHAR (100)  NULL,
    [id_frequency_payment]     INT             NULL,
    [name_frequency_payment]   NVARCHAR (100)  NULL,
    [color_payment]            NVARCHAR (100)  NULL,
    [id_version_payment]       INT             CONSTRAINT [DF_k_transaction_master_payment_publication_id_version_payment] DEFAULT ((-2)) NOT NULL,
    [name_version_payment]     NVARCHAR (100)  NULL,
    [amount_trans_payment]     DECIMAL (18, 4) NULL,
    [unit_trans_payment]       NVARCHAR (50)   NULL,
    [id_status_payment]        INT             NULL,
    [name_status_payment]      NVARCHAR (100)  NULL,
    [date_trans_payment]       DATETIME        NULL,
    [id_group1_payment]        INT             NULL,
    [name_group1_payment]      NVARCHAR (100)  NULL,
    [id_group2_payment]        INT             NULL,
    [name_group2_payment]      NVARCHAR (100)  NULL,
    [id_group3_payment]        INT             NULL,
    [name_group3_payment]      NVARCHAR (100)  NULL,
    [id_group4_payment]        INT             NULL,
    [name_group4_payment]      NVARCHAR (100)  NULL,
    [id_group5_payment]        INT             NULL,
    [name_group5_payment]      NVARCHAR (100)  NULL,
    [id_owner]                 INT             NULL,
    CONSTRAINT [PK_k_transaction_master_payment_publication] PRIMARY KEY CLUSTERED ([id_publication_master] ASC),
    CONSTRAINT [FK_k_transaction_master_payment_publication_k_versions] FOREIGN KEY ([id_version_payment]) REFERENCES [dbo].[k_versions] ([id_version])
);
