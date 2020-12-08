CREATE TABLE [dbo].[nc_DocuSignMapping] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [id_document]     INT            NOT NULL,
    [id_grid_field]   INT            NOT NULL,
    [id_docusign_tab] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_nc_DocuSignMapping] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_nc_DocuSignMapping_k_referential_grids_fields] FOREIGN KEY ([id_grid_field]) REFERENCES [dbo].[k_referential_grids_fields] ([id_column]),
    CONSTRAINT [FK_nc_DocuSignMapping_nc_Document] FOREIGN KEY ([id_document]) REFERENCES [dbo].[nc_Document] ([id])
);


GO
CREATE NONCLUSTERED INDEX [IX_nc_DocuSignMapping_id_document]
    ON [dbo].[nc_DocuSignMapping]([id_document] ASC);

