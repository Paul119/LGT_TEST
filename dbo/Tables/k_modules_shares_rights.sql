CREATE TABLE [dbo].[k_modules_shares_rights] (
    [id_share]         INT IDENTITY (1, 1) NOT NULL,
    [id_module_right]  INT NULL,
    [id_source_tenant] INT NULL,
    [id_source]        INT NULL,
    [id_change_set]    INT NULL,
    CONSTRAINT [PK_k_modules_shares_rights] PRIMARY KEY CLUSTERED ([id_share] ASC),
    CONSTRAINT [FK_k_modules_shares_rights_k_modules_rights] FOREIGN KEY ([id_module_right]) REFERENCES [dbo].[k_modules_rights] ([id_module_right])
);

