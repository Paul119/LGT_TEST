CREATE TABLE [dbo].[k_m_plans_affectations] (
    [id_affectation]          INT           IDENTITY (1, 1) NOT NULL,
    [id_plan]                 INT           NULL,
    [type_affectation]        CHAR (1)      NOT NULL,
    [id_assignee]             INT           NOT NULL,
    [name_assignee]           NVARCHAR (50) NULL,
    [id_owner]                INT           NULL,
    [date_create_affectation] DATETIME      NULL,
    [id_user_update]          INT           NULL,
    [date_update_affectation] DATETIME      NULL,
    [idPopVersion]            INT           NULL,
    [id_source_tenant]        INT           NULL,
    [id_source]               INT           NULL,
    [id_change_set]           INT           NULL,
    CONSTRAINT [PK_k_m_plans_affectations] PRIMARY KEY CLUSTERED ([id_affectation] ASC),
    CONSTRAINT [FK_k_m_plans_affectations_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_k_m_plans_affectations_pop_PopulationVersion] FOREIGN KEY ([idPopVersion]) REFERENCES [dbo].[pop_PopulationVersion] ([id])
);

