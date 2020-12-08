CREATE TABLE [dbo].[k_referential_grid_import_histo] (
    [id_grid_import_histo]       INT            IDENTITY (1, 1) NOT NULL,
    [id_user]                    INT            NOT NULL,
    [import_date]                DATETIME       NULL,
    [file_name]                  NVARCHAR (MAX) NOT NULL,
    [number_of_records_in_file]  INT            NULL,
    [number_of_records_accepted] INT            NULL,
    [number_of_records_rejected] INT            NULL,
    [id_grid]                    INT            NOT NULL,
    CONSTRAINT [PK_k_referential_grid_import_histo] PRIMARY KEY CLUSTERED ([id_grid_import_histo] ASC),
    CONSTRAINT [FK_k_referential_grid_import_histo_k_referential_grids] FOREIGN KEY ([id_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid]),
    CONSTRAINT [FK_k_referential_grid_import_histo_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user])
);

