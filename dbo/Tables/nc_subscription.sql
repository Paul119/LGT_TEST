CREATE TABLE [dbo].[nc_subscription] (
    [id]                  INT              IDENTITY (1, 1) NOT NULL,
    [id_table_view]       INT              NULL,
    [format]              VARCHAR (10)     NULL,
    [year]                SMALLINT         NULL,
    [period]              VARCHAR (10)     NULL,
    [priority]            VARCHAR (10)     NULL,
    [day]                 SMALLINT         NULL,
    [hour]                SMALLINT         NULL,
    [is_report_included]  BIT              NULL,
    [uid]                 UNIQUEIDENTIFIER NULL,
    [extension_type]      INT              NULL,
    [id_document]         INT              NULL,
    [id_last_execution]   INT              NULL,
    [date_last_execution] DATETIME         NULL,
    [query_count]         INT              NULL,
    CONSTRAINT [PK_nc_report_detail] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_nc_subscription_nc_Document] FOREIGN KEY ([id_document]) REFERENCES [dbo].[nc_Document] ([id])
);

