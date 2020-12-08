CREATE TABLE [ds].[bqm_datasource_status] (
    [uid_datasource_status] UNIQUEIDENTIFIER CONSTRAINT [DF_bqm_datasource_status_uid_datasource_status] DEFAULT (newsequentialid()) NOT NULL,
    [name]                  NVARCHAR (100)   NOT NULL,
    [description]           NVARCHAR (250)   NULL,
    [uid_user_create]       UNIQUEIDENTIFIER NOT NULL,
    [date_create]           DATETIME         NOT NULL,
    [is_deleted]            BIT              CONSTRAINT [DF_bqm_datasource_status_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_bqm_datasource_status] PRIMARY KEY CLUSTERED ([uid_datasource_status] ASC)
);

