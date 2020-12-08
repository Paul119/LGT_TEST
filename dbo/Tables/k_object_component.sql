CREATE TABLE [dbo].[k_object_component] (
    [id_component]   INT            IDENTITY (1, 1) NOT NULL,
    [id_object]      INT            NOT NULL,
    [id_data_source] INT            NULL,
    [field_alias]    NVARCHAR (50)  NULL,
    [association]    INT            NULL,
    [validation]     NVARCHAR (MAX) NULL,
    [aggregation]    INT            NULL,
    [filter]         INT            NULL,
    [sort]           INT            NULL,
    [reference_key]  NVARCHAR (50)  NOT NULL,
    [is_mandatory]   BIT            CONSTRAINT [DF_k_object_component_is_mandatory] DEFAULT ((0)) NOT NULL,
    [component_type] SMALLINT       NOT NULL,
    CONSTRAINT [PK_k_object_component] PRIMARY KEY CLUSTERED ([id_component] ASC),
    CONSTRAINT [fk_k_object_component_id_data_source] FOREIGN KEY ([id_data_source]) REFERENCES [dbo].[k_data_source] ([id_data_source]),
    CONSTRAINT [fk_k_object_component_id_object_k_object_id_object] FOREIGN KEY ([id_object]) REFERENCES [dbo].[k_object] ([id_object]),
    CONSTRAINT [k_object_component_association_FK] FOREIGN KEY ([association]) REFERENCES [dbo].[k_data_source] ([id_data_source])
);

