CREATE TABLE [dbo].[app_tenantinfo_template_log] (
    [id_template_log]    INT              IDENTITY (1, 1) NOT NULL,
    [UID_template]       UNIQUEIDENTIFIER NOT NULL,
    [event_template_log] NVARCHAR (MAX)   NOT NULL,
    [create_date]        DATETIME         NOT NULL,
    CONSTRAINT [PK_app_tenantinfo_template_log] PRIMARY KEY CLUSTERED ([id_template_log] ASC)
);

