CREATE TABLE [dbo].[k_transaction_master_value] (
    [id_trans_master] INT IDENTITY (1, 1) NOT NULL,
    [id_prog_value]   INT NULL,
    [id_cond]         INT NULL,
    [id_simulation]   INT CONSTRAINT [DF_k_transaction_master_value_id_simulation] DEFAULT ((0)) NOT NULL,
    [is_deleted]      BIT NULL,
    [id_owner]        INT NULL,
    CONSTRAINT [PK_k_transaction_master_value] PRIMARY KEY CLUSTERED ([id_trans_master] ASC)
);

