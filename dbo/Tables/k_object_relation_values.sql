CREATE TABLE [dbo].[k_object_relation_values] (
    [id]                 INT IDENTITY (1, 1) NOT NULL,
    [id_object_relation] INT NULL,
    [base_item]          INT NULL,
    [related_item]       INT NULL,
    [value_order]        INT NULL,
    [value_type]         INT NULL,
    CONSTRAINT [PK_k_object_relation_values] PRIMARY KEY CLUSTERED ([id] ASC) WITH (IGNORE_DUP_KEY = ON)
);

