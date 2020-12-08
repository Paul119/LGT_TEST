CREATE TABLE [dbo].[k_unit] (
    [unit_id]        INT            IDENTITY (1, 1) NOT NULL,
    [unit_name]      NVARCHAR (50)  NOT NULL,
    [unit_long_name] NVARCHAR (150) NULL,
    [is_spindle]     BIT            NULL,
    [sort]           INT            NULL,
    CONSTRAINT [PK_k_unit] PRIMARY KEY CLUSTERED ([unit_id] ASC)
);

