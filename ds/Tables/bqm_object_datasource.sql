CREATE TABLE [ds].[bqm_object_datasource] (
    [uid_object_datasource] UNIQUEIDENTIFIER CONSTRAINT [DF_bqm_object_datasource_uid_object_datasource] DEFAULT (newsequentialid()) NOT NULL,
    [uid_tenant]            UNIQUEIDENTIFIER NULL,
    [uid_object]            UNIQUEIDENTIFIER NULL,
    [uid_datasource]        UNIQUEIDENTIFIER NULL,
    [is_aggregated]         BIT              NULL,
    [uid_user_create]       UNIQUEIDENTIFIER NOT NULL,
    [date_create]           DATETIME         NOT NULL,
    CONSTRAINT [PK_bqm_object_datasource] PRIMARY KEY CLUSTERED ([uid_object_datasource] ASC),
    CONSTRAINT [fk_bqm_object_datasource_uid_datasource_bqm_datasource_uid_datasource] FOREIGN KEY ([uid_datasource]) REFERENCES [ds].[bqm_datasource] ([uid_datasource])
);

