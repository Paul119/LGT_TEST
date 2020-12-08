CREATE TABLE [ds].[bqm_datasource_attribute_type] (
    [uid_datasource_attribute_type] UNIQUEIDENTIFIER CONSTRAINT [DF_bqm_datasource_attribute_type_uid_datasource_attribute_type] DEFAULT (newsequentialid()) NOT NULL,
    [name]                          NVARCHAR (100)   NOT NULL,
    [description]                   NVARCHAR (250)   NULL,
    [code]                          INT              NOT NULL,
    [uid_user_create]               UNIQUEIDENTIFIER NOT NULL,
    [date_create]                   DATETIME         NOT NULL,
    [is_deleted]                    BIT              CONSTRAINT [DF_bqm_datasource_attribute_type_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_bqm_datasource_attribute_type] PRIMARY KEY CLUSTERED ([uid_datasource_attribute_type] ASC)
);

