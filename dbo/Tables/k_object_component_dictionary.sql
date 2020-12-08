CREATE TABLE [dbo].[k_object_component_dictionary] (
    [id_object_component_dictionary] UNIQUEIDENTIFIER CONSTRAINT [DF_k_object_component_dictionary_id_object_component_dictionary] DEFAULT (newid()) NOT NULL,
    [id_object_component]            INT              NOT NULL,
    [value]                          INT              NOT NULL,
    [display_text]                   NVARCHAR (100)   NOT NULL,
    [ref]                            UNIQUEIDENTIFIER DEFAULT (NULL) NULL,
    CONSTRAINT [PK_k_object_component_dictionary] PRIMARY KEY CLUSTERED ([id_object_component_dictionary] ASC),
    CONSTRAINT [fk_k_object_component_dictionary_id_object_component_k_object_component_id_component] FOREIGN KEY ([id_object_component]) REFERENCES [dbo].[k_object_component] ([id_component])
);

