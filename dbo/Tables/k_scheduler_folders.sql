CREATE TABLE [dbo].[k_scheduler_folders] (
    [id_folder]          INT            IDENTITY (1, 1) NOT NULL,
    [id_parent_folder]   INT            NULL,
    [name_folder]        NVARCHAR (100) NULL,
    [deep_folder]        SMALLINT       NULL,
    [id_owner]           INT            NULL,
    [date_created]       SMALLDATETIME  NULL,
    [date_last_modified] SMALLDATETIME  NULL,
    [id_source_tenant]   INT            NULL,
    [id_source]          INT            NULL,
    [id_change_set]      INT            NULL,
    CONSTRAINT [PK_k_scheduler_folders] PRIMARY KEY CLUSTERED ([id_folder] ASC),
    CONSTRAINT [FK_k_scheduler_folders_k_scheduler_folders] FOREIGN KEY ([id_parent_folder]) REFERENCES [dbo].[k_scheduler_folders] ([id_folder])
);

