CREATE TABLE [dbo].[k_program_execution_plan] (
    [id_schedule]        INT           IDENTITY (1, 1) NOT NULL,
    [idParentFolder]     INT           NULL,
    [name_schedule]      NVARCHAR (50) NOT NULL,
    [date_last_schedule] DATETIME      NULL,
    [date_next_schedule] DATETIME      NULL,
    [id_owner]           INT           NULL,
    [date_created]       SMALLDATETIME NULL,
    [date_last_modified] SMALLDATETIME NULL,
    [id_source_tenant]   INT           NULL,
    [id_source]          INT           NULL,
    [id_change_set]      INT           NULL,
    CONSTRAINT [PK_k_program_schedule] PRIMARY KEY CLUSTERED ([id_schedule] ASC),
    CONSTRAINT [FK_k_program_schedule_k_scheduler_folders] FOREIGN KEY ([idParentFolder]) REFERENCES [dbo].[k_scheduler_folders] ([id_folder])
);

