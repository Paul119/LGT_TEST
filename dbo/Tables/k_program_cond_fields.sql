CREATE TABLE [dbo].[k_program_cond_fields] (
    [id_field]              INT            IDENTITY (1, 1) NOT NULL,
    [id_folder]             INT            NOT NULL,
    [name_field]            NVARCHAR (50)  NULL,
    [javascript_field]      NVARCHAR (100) NULL,
    [value_field_view]      NVARCHAR (50)  NOT NULL,
    [value_field_preview]   NVARCHAR (50)  NULL,
    [table_field_preview]   NVARCHAR (255) NOT NULL,
    [type_field_preview]    NVARCHAR (50)  NULL,
    [display_field_preview] NVARCHAR (50)  NULL,
    [is_parameter]          BIT            CONSTRAINT [DF_k_program_cond_fields_is_parameter] DEFAULT ((0)) NOT NULL,
    [name_parameter]        NVARCHAR (100) NULL,
    [id_source_tenant]      INT            NULL,
    [id_source]             INT            NULL,
    [id_change_set]         INT            NULL,
    CONSTRAINT [PK__k_condition_fiel__1CE7F9F6] PRIMARY KEY CLUSTERED ([id_field] ASC),
    CONSTRAINT [FK_k_program_cond_fields_k_program_cond_folders] FOREIGN KEY ([id_folder]) REFERENCES [dbo].[k_program_cond_folders] ([id_folder])
);

