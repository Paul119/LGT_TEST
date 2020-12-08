CREATE TABLE [dbo].[k_modules] (
    [id_module]         INT            IDENTITY (1, 1) NOT NULL,
    [id_parent_module]  INT            NULL,
    [name_module]       NVARCHAR (100) NULL,
    [id_module_type]    INT            NULL,
    [id_tab]            INT            NULL,
    [id_item]           INT            NULL,
    [order_module]      INT            NULL,
    [id_source_tenant]  INT            NULL,
    [id_source]         INT            NULL,
    [id_change_set]     INT            NULL,
    [show_in_accordion] BIT            CONSTRAINT [DF_k_modules_show_in_accordion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_k_modules] PRIMARY KEY CLUSTERED ([id_module] ASC),
    CONSTRAINT [FK_k_modules_k_modules] FOREIGN KEY ([id_parent_module]) REFERENCES [dbo].[k_modules] ([id_module]),
    CONSTRAINT [FK_k_modules_k_modules_types] FOREIGN KEY ([id_module_type]) REFERENCES [dbo].[k_modules_types] ([id_module_type])
);

