CREATE TABLE [dbo].[k_reports_folders] (
    [id_folder]        INT            IDENTITY (1, 1) NOT NULL,
    [id_parent]        INT            NULL,
    [name_folder]      NVARCHAR (255) NULL,
    [public_folder]    BIT            NULL,
    [sort_folder]      INT            NULL,
    [type_folder]      INT            NULL,
    [id_source_tenant] INT            NULL,
    [id_source]        INT            NULL,
    [id_change_set]    INT            NULL,
    [id_owner]         INT            NOT NULL,
    CONSTRAINT [PK_k_reports_folder] PRIMARY KEY CLUSTERED ([id_folder] ASC),
    CONSTRAINT [FK_k_reports_folder_k_reports_folder] FOREIGN KEY ([id_parent]) REFERENCES [dbo].[k_reports_folders] ([id_folder])
);


GO
CREATE NONCLUSTERED INDEX [IX__k_reports_folders__id_parent]
    ON [dbo].[k_reports_folders]([id_parent] ASC);

