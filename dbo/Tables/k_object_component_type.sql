CREATE TABLE [dbo].[k_object_component_type] (
    [id_object_component_type] INT            IDENTITY (1, 1) NOT NULL,
    [name]                     NVARCHAR (250) NOT NULL,
    [data_type]                SMALLINT       NOT NULL,
    [component_type]           SMALLINT       NOT NULL,
    [is_mandatory]             BIT            CONSTRAINT [DF_k_object_component_type_is_mandatory] DEFAULT ((0)) NOT NULL,
    [max_length]               SMALLINT       NULL,
    [precision]                SMALLINT       NULL,
    [scale]                    SMALLINT       NULL,
    CONSTRAINT [PK_k_object_component_type] PRIMARY KEY CLUSTERED ([id_object_component_type] ASC)
);

