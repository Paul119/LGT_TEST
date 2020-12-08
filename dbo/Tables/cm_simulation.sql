CREATE TABLE [dbo].[cm_simulation] (
    [simulation_id]    INT            IDENTITY (1, 1) NOT NULL,
    [simulation_name]  NVARCHAR (250) NULL,
    [id_process]       INT            NULL,
    [id_user]          INT            NULL,
    [create_date]      DATETIME       NULL,
    [id_source_tenant] INT            NULL,
    [id_source]        INT            NULL,
    [id_change_set]    INT            NULL,
    [id_type]          INT            CONSTRAINT [DF_cm_simulation_id_type] DEFAULT ((-1)) NOT NULL,
    CONSTRAINT [PK_cm_simulation] PRIMARY KEY CLUSTERED ([simulation_id] ASC),
    CONSTRAINT [FK_cm_simulation_k_m_plans] FOREIGN KEY ([id_process]) REFERENCES [dbo].[k_m_plans] ([id_plan])
);

