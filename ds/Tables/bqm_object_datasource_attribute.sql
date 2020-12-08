CREATE TABLE [ds].[bqm_object_datasource_attribute] (
    [uid_object_datasource_attribute] UNIQUEIDENTIFIER NULL,
    [uid_tenant]                      UNIQUEIDENTIFIER NULL,
    [uid_object_datasource]           UNIQUEIDENTIFIER NOT NULL,
    [uid_datasource_attribute]        UNIQUEIDENTIFIER NOT NULL,
    [reference]                       UNIQUEIDENTIFIER NULL,
    [uid_aggregation_function]        UNIQUEIDENTIFIER NULL,
    [uid_user_create]                 UNIQUEIDENTIFIER NOT NULL,
    [date_create]                     DATETIME         NOT NULL,
    CONSTRAINT [fk_bqm_object_datasource_attribute_uid_datasource_attribute_bqm_object_datasource_attribute_uid_datasource_attribute] FOREIGN KEY ([uid_datasource_attribute]) REFERENCES [ds].[bqm_datasource_attribute] ([uid_datasource_attribute]),
    CONSTRAINT [fk_bqm_object_datasource_attribute_uid_object_datasource_bqm_object_type_uid_object_datasource] FOREIGN KEY ([uid_object_datasource]) REFERENCES [ds].[bqm_object_datasource] ([uid_object_datasource])
);

