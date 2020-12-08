CREATE TABLE [dbo].[app_tenantinfo_template_status] (
    [id_tenantinfo_template_status]   INT            IDENTITY (1, 1) NOT NULL,
    [name_tenantinfo_template_status] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_app_tenantinfo_template_status] PRIMARY KEY CLUSTERED ([id_tenantinfo_template_status] ASC)
);

