CREATE TABLE [dbo].[k_transaction_master_earn] (
    [id_trans_master]       INT            IDENTITY (1, 1) NOT NULL,
    [id_folder_prog_earn]   INT            NULL,
    [name_folder_prog_earn] NVARCHAR (50)  NULL,
    [id_prog_earn]          INT            NULL,
    [name_prog_earn]        NVARCHAR (100) NULL,
    [id_cond_earn]          INT            NULL,
    [name_cond_earn]        NVARCHAR (100) NULL,
    [sql_cond_earn]         NVARCHAR (MAX) NULL,
    [sql_calc_earn]         NVARCHAR (MAX) NULL,
    [id_type_earn]          INT            NULL,
    [name_type_earn]        NVARCHAR (100) NULL,
    [id_category_earn]      INT            NULL,
    [name_category_earn]    NVARCHAR (100) NULL,
    [id_frequency_earn]     INT            NULL,
    [name_frequency_earn]   NVARCHAR (100) NULL,
    [color_earn]            NVARCHAR (100) NULL,
    [id_version_earn]       INT            CONSTRAINT [DF_k_transaction_master_earn_id_version_earn] DEFAULT ((-2)) NOT NULL,
    [name_version_earn]     NVARCHAR (100) NULL,
    [unit_trans_earn]       NVARCHAR (50)  NULL,
    [id_status_earn]        INT            NULL,
    [name_status_earn]      NVARCHAR (100) NULL,
    [date_trans_earn]       SMALLDATETIME  NULL,
    [id_group1_earn]        INT            NULL,
    [name_group1_earn]      NVARCHAR (100) NULL,
    [id_group2_earn]        INT            NULL,
    [name_group2_earn]      NVARCHAR (100) NULL,
    [id_group3_earn]        INT            NULL,
    [name_group3_earn]      NVARCHAR (100) NULL,
    [id_group4_earn]        INT            NULL,
    [name_group4_earn]      NVARCHAR (100) NULL,
    [id_group5_earn]        INT            NULL,
    [name_group5_earn]      NVARCHAR (100) NULL,
    [is_deleted]            BIT            CONSTRAINT [DF_k_transaction_master_earn_is_deleted] DEFAULT ((0)) NOT NULL,
    [id_simulation]         INT            CONSTRAINT [DF_k_transaction_master_earn_id_simulation] DEFAULT ((0)) NOT NULL,
    [id_owner]              INT            NULL,
    CONSTRAINT [PK_k_transaction_master_earn] PRIMARY KEY CLUSTERED ([id_trans_master] ASC),
    CONSTRAINT [FK_k_transaction_master_earn_k_versions] FOREIGN KEY ([id_version_earn]) REFERENCES [dbo].[k_versions] ([id_version])
);


GO
CREATE NONCLUSTERED INDEX [NCIX_k_transaction_master_earn_IDNameGroup2]
    ON [dbo].[k_transaction_master_earn]([id_trans_master] ASC, [name_group2_earn] ASC)
    INCLUDE([id_group1_earn], [id_group2_earn]);

