CREATE TABLE [ds].[bqm_datasource_attribute] (
    [uid_datasource_attribute]      UNIQUEIDENTIFIER CONSTRAINT [DF_bqm_datasource_attribute_uid_datasource_attribute] DEFAULT (newsequentialid()) NOT NULL,
    [uid_tenant]                    UNIQUEIDENTIFIER NULL,
    [name]                          NVARCHAR (250)   NOT NULL,
    [alias]                         NVARCHAR (250)   NOT NULL,
    [description]                   NVARCHAR (500)   NULL,
    [uid_datasource_attribute_type] UNIQUEIDENTIFIER NULL,
    [uid_datasource_status]         UNIQUEIDENTIFIER NULL,
    [uid_datasource]                UNIQUEIDENTIFIER NULL,
    [max_length]                    INT              NULL,
    [precision]                     SMALLINT         NULL,
    [scale]                         SMALLINT         NULL,
    [is_mandatory]                  BIT              CONSTRAINT [DF_bqm_datasource_attribute_is_mandatory] DEFAULT ((0)) NOT NULL,
    [uid_user_create]               UNIQUEIDENTIFIER NOT NULL,
    [date_create]                   DATETIME         NOT NULL,
    [uid_user_modify]               UNIQUEIDENTIFIER NULL,
    [date_modify]                   DATETIME         NULL,
    [is_deleted]                    BIT              CONSTRAINT [DF_bqm_datasource_attribute_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_bqm_datasource_attribute] PRIMARY KEY CLUSTERED ([uid_datasource_attribute] ASC),
    CONSTRAINT [fk_bqm_datasource_attribute_uid_datasource_attribute_type_bqm_object_type_uid_datasource_attribute_type] FOREIGN KEY ([uid_datasource_attribute_type]) REFERENCES [ds].[bqm_datasource_attribute_type] ([uid_datasource_attribute_type]),
    CONSTRAINT [fk_bqm_datasource_attribute_uid_datasource_bqm_object_type_uid_datasource] FOREIGN KEY ([uid_datasource]) REFERENCES [ds].[bqm_datasource] ([uid_datasource]),
    CONSTRAINT [fk_bqm_datasource_attribute_uid_datasource_status_bqm_object_type_uid_datasource_status] FOREIGN KEY ([uid_datasource_status]) REFERENCES [ds].[bqm_datasource_status] ([uid_datasource_status])
);

