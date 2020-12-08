CREATE TABLE [dbo].[k_modules_rights] (
    [id_module_right]  INT IDENTITY (1, 1) NOT NULL,
    [id_module]        INT NOT NULL,
    [id_right]         INT NOT NULL,
    [id_source_tenant] INT NULL,
    [id_source]        INT NULL,
    [id_change_set]    INT NULL,
    CONSTRAINT [PK_k_modules_rights] PRIMARY KEY CLUSTERED ([id_module_right] ASC),
    CONSTRAINT [FK_k_modules_rights_k_modules] FOREIGN KEY ([id_module]) REFERENCES [dbo].[k_modules] ([id_module]),
    CONSTRAINT [FK_k_modules_rights_k_rights] FOREIGN KEY ([id_right]) REFERENCES [dbo].[k_rights] ([id_right])
);

