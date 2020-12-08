CREATE TABLE [dbo].[k_object] (
    [id_object]                INT            IDENTITY (1, 1) NOT NULL,
    [id_data_source_main]      INT            NULL,
    [type_object]              SMALLINT       NOT NULL,
    [name_object]              NVARCHAR (250) NOT NULL,
    [place_object]             SMALLINT       NOT NULL,
    [layout]                   NVARCHAR (MAX) NULL,
    [id_master_data_source]    INT            NULL,
    [master_data_source_field] NVARCHAR (250) NOT NULL,
    [id_status]                INT            CONSTRAINT [DF_k_object_id_status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_k_object] PRIMARY KEY CLUSTERED ([id_object] ASC),
    CONSTRAINT [fk_k_data_source_id_data_source_k_object_id_data_source_main] FOREIGN KEY ([id_data_source_main]) REFERENCES [dbo].[k_data_source] ([id_data_source]),
    CONSTRAINT [fk_k_data_source_id_data_source_k_object_id_master_data_source] FOREIGN KEY ([id_master_data_source]) REFERENCES [dbo].[k_data_source] ([id_data_source])
);

