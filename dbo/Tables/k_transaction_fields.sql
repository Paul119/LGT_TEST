CREATE TABLE [dbo].[k_transaction_fields] (
    [id_field]         INT           IDENTITY (-21, -1) NOT NULL,
    [field_name]       NVARCHAR (50) NULL,
    [id_universe_type] INT           NULL,
    [field_type]       NVARCHAR (50) NULL,
    [field_length]     FLOAT (53)    NULL,
    [required]         BIT           NULL,
    [order]            INT           NULL,
    CONSTRAINT [PK_k_transaction_fields] PRIMARY KEY CLUSTERED ([id_field] ASC)
);

