CREATE TABLE [dbo].[rps_file] (
    [id_file]                 INT            IDENTITY (1, 1) NOT NULL,
    [id_document]             INT            NULL,
    [id_payee]                INT            NOT NULL,
    [id_file_status]          INT            NOT NULL,
    [comment]                 NVARCHAR (MAX) NULL,
    [create_date]             SMALLDATETIME  NULL,
    [seen_date]               SMALLDATETIME  NULL,
    [download_date]           SMALLDATETIME  NULL,
    [fileSize]                INT            NULL,
    [file_name]               NVARCHAR (100) NULL,
    [id_validation_status]    INT            NULL,
    [id_docusign_envelope]    NVARCHAR (100) NULL,
    [docusign_tab_data]       XML            NULL,
    [docusign_sent_date]      DATETIME       NULL,
    [docusign_signed_date]    DATETIME       NULL,
    [docusign_declined_date]  DATETIME       NULL,
    [docusign_decline_reason] NVARCHAR (500) NULL,
    [docusign_voided_date]    DATETIME       NULL,
    [docusign_void_reason]    NVARCHAR (500) NULL,
    [id_batch]                INT            NULL,
    CONSTRAINT [PK_rps_file] PRIMARY KEY CLUSTERED ([id_file] ASC),
    CONSTRAINT [FK_rps_file_nc_document] FOREIGN KEY ([id_document]) REFERENCES [dbo].[nc_Document] ([id]),
    CONSTRAINT [FK_rps_file_nc_Document_DocuSignBatch] FOREIGN KEY ([id_batch]) REFERENCES [dbo].[nc_Document_DocuSignBatch] ([id_batch]),
    CONSTRAINT [FK_rps_file_rps_file_status] FOREIGN KEY ([id_file_status]) REFERENCES [dbo].[rps_file_status] ([id_file_status]),
    CONSTRAINT [FK_rps_file_rps_file_validation_status] FOREIGN KEY ([id_validation_status]) REFERENCES [dbo].[rps_file_validation_status] ([id_file_validation_status])
);


GO
CREATE NONCLUSTERED INDEX [IX_rps_file_id_docusign_envelope]
    ON [dbo].[rps_file]([id_docusign_envelope] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_rps_file_id_payee]
    ON [dbo].[rps_file]([id_payee] ASC);

