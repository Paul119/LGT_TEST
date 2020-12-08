CREATE TABLE [dbo].[k_dashboard_widget] (
    [id_dashboard_widget] INT              IDENTITY (1, 1) NOT NULL,
    [id_dashboard]        INT              NULL,
    [uid_object]          UNIQUEIDENTIFIER NOT NULL,
    [is_mandatory]        BIT              NULL,
    [x]                   INT              NULL,
    [y]                   INT              NULL,
    [w]                   INT              NULL,
    [h]                   INT              NULL,
    CONSTRAINT [PK_k_dashboard_widget] PRIMARY KEY CLUSTERED ([id_dashboard_widget] ASC)
);

