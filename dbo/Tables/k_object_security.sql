CREATE TABLE [dbo].[k_object_security] (
    [id_object_security]            INT            IDENTITY (1, 1) NOT NULL,
    [id_table_view]                 INT            NOT NULL,
    [is_access_table_view_allowed]  BIT            CONSTRAINT [DF_k_object_security_is_access_table_view_allowed] DEFAULT ((1)) NOT NULL,
    [is_manage_security_allowed]    BIT            CONSTRAINT [DF_k_object_security_is_manage_security_allowed] DEFAULT ((0)) NOT NULL,
    [security_criteria]             NVARCHAR (MAX) NOT NULL,
    [id_object_security_table_view] INT            NOT NULL,
    CONSTRAINT [PK_k_object_security] PRIMARY KEY CLUSTERED ([id_object_security] ASC),
    CONSTRAINT [FK_k_object_security_k_referential_tables_views] FOREIGN KEY ([id_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view]),
    CONSTRAINT [FK_k_object_security_k_referential_tables_views1] FOREIGN KEY ([id_object_security_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view])
);

