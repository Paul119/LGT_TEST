CREATE TABLE [dbo].[nc_Document_DocuSignBatch] (
    [id_batch]                   INT           IDENTITY (1, 1) NOT NULL,
    [id_document]                INT           NOT NULL,
    [id_docusign_batch]          VARCHAR (50)  NULL,
    [date_batch_queue_entry]     SMALLDATETIME CONSTRAINT [DF_nc_Document_DocuSignBatch_date_batch_queue_entry] DEFAULT (getutcdate()) NOT NULL,
    [date_batch_queue_processed] SMALLDATETIME NULL,
    CONSTRAINT [PK_nc_Document_DocuSignBatch] PRIMARY KEY CLUSTERED ([id_batch] ASC),
    CONSTRAINT [FK_nc_Document_DocuSignBatch_Document] FOREIGN KEY ([id_document]) REFERENCES [dbo].[nc_Document] ([id])
);


GO
CREATE NONCLUSTERED INDEX [IX_nc_Document_DocuSignBatch_id_document]
    ON [dbo].[nc_Document_DocuSignBatch]([id_document] ASC);

