CREATE TABLE [ds].[bqm_datasource_type] (
    [uid_datasource_type] UNIQUEIDENTIFIER CONSTRAINT [DF_bqm_datasource_type_uid_datasource_type] DEFAULT (newsequentialid()) NOT NULL,
    [name]                NVARCHAR (100)   NOT NULL,
    [description]         NVARCHAR (250)   NULL,
    [uid_user_create]     UNIQUEIDENTIFIER NOT NULL,
    [date_create]         DATETIME         NOT NULL,
    [is_deleted]          BIT              CONSTRAINT [DF_bqm_datasource_type_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_bqm_datasource_type] PRIMARY KEY CLUSTERED ([uid_datasource_type] ASC)
);

