CREATE TABLE [dbo].[cm_ProcessRule] (
    [id_ProcessRule] INT           IDENTITY (1, 1) NOT NULL,
    [id_Process]     INT           NULL,
    [id_prog]        INT           NULL,
    [name_prog]      NVARCHAR (50) NULL,
    CONSTRAINT [PK_cm_ProcessRule] PRIMARY KEY CLUSTERED ([id_ProcessRule] ASC),
    CONSTRAINT [FK_cm_ProcessRule_k_m_plans] FOREIGN KEY ([id_Process]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_cm_ProcessRule_k_program] FOREIGN KEY ([id_prog]) REFERENCES [dbo].[k_program] ([id_prog]) ON DELETE CASCADE
);

