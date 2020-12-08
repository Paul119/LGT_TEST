CREATE TABLE [dbo].[app_tenantinfo_template] (
    [id_tenantinfo_template] INT              IDENTITY (1, 1) NOT NULL,
    [UID_template]           UNIQUEIDENTIFIER NOT NULL,
    [activate_date]          DATETIME         NOT NULL,
    [status_template]        INT              NOT NULL,
    CONSTRAINT [PK_app_tenantinfo_template] PRIMARY KEY CLUSTERED ([id_tenantinfo_template] ASC),
    CONSTRAINT [FK_app_tenantinfo_template_status_template] FOREIGN KEY ([status_template]) REFERENCES [dbo].[app_tenantinfo_template_status] ([id_tenantinfo_template_status])
);

