CREATE TABLE [dbo].[k_schedule] (
    [id_schedule]              INT              IDENTITY (1, 1) NOT NULL,
    [name_schedule]            NVARCHAR (100)   NOT NULL,
    [uid_job_sqlagent]         UNIQUEIDENTIFIER NULL,
    [id_job_scheduler_service] INT              NULL,
    [is_visible]               BIT              DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_k_schedule] PRIMARY KEY CLUSTERED ([id_schedule] ASC)
);

