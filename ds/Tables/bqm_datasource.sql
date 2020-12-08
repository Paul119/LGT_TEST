CREATE TABLE [ds].[bqm_datasource] (
    [uid_datasource]         UNIQUEIDENTIFIER CONSTRAINT [DF_bqm_datasource_uid_datasource] DEFAULT (newsequentialid()) NOT NULL,
    [uid_tenant]             UNIQUEIDENTIFIER NULL,
    [name]                   NVARCHAR (250)   NOT NULL,
    [description]            NVARCHAR (500)   NULL,
    [uid_datasource_type]    UNIQUEIDENTIFIER NULL,
    [uid_datasource_status]  UNIQUEIDENTIFIER NULL,
    [extended_configuration] NVARCHAR (MAX)   NULL,
    [code]                   NVARCHAR (50)    NULL,
    [is_editable]            BIT              CONSTRAINT [DF_bqm_datasource_is_editable] DEFAULT ((0)) NOT NULL,
    [external_datasource]    BIT              CONSTRAINT [DF_bqm_datasource_external_datasource] DEFAULT ((0)) NOT NULL,
    [uid_key_attribute]      UNIQUEIDENTIFIER NULL,
    [uid_user_create]        UNIQUEIDENTIFIER NOT NULL,
    [date_create]            DATETIME         NOT NULL,
    [uid_user_modify]        UNIQUEIDENTIFIER NULL,
    [date_modify]            DATETIME         NULL,
    [is_deleted]             BIT              CONSTRAINT [DF_bqm_datasource_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_bqm_datasource] PRIMARY KEY CLUSTERED ([uid_datasource] ASC),
    CONSTRAINT [fk_bqm_datasource_uid_datasource_status_bqm_object_type_uid_datasource_status] FOREIGN KEY ([uid_datasource_status]) REFERENCES [ds].[bqm_datasource_status] ([uid_datasource_status]),
    CONSTRAINT [fk_bqm_datasource_uid_datasource_type_bqm_object_type_uid_datasource_type] FOREIGN KEY ([uid_datasource_type]) REFERENCES [ds].[bqm_datasource_type] ([uid_datasource_type]),
    CONSTRAINT [fk_bqm_datasource_uid_key_attribute_bqm_datasource_attribute_uid_datasource_attribute] FOREIGN KEY ([uid_key_attribute]) REFERENCES [ds].[bqm_datasource_attribute] ([uid_datasource_attribute])
);

