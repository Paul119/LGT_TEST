CREATE TABLE [dbo].[cm_simulation_indicator_field_accessibility] (
    [id_simulation_indicator_field_access] INT IDENTITY (1, 1) NOT NULL,
    [id_simulation]                        INT NULL,
    [id_plan_indicator]                    INT NULL,
    [id_indicator_field]                   INT NULL,
    [id_access_type]                       INT NULL,
    CONSTRAINT [PK__cm_simul__23CCEE024A7CC47B] PRIMARY KEY CLUSTERED ([id_simulation_indicator_field_access] ASC),
    CONSTRAINT [FK_cm_simulation_indicator_field_accessibility_cm_simulation] FOREIGN KEY ([id_simulation]) REFERENCES [dbo].[cm_simulation] ([simulation_id]),
    CONSTRAINT [FK_cm_simulation_indicator_field_accessibility_k_m_indicators_fields] FOREIGN KEY ([id_indicator_field]) REFERENCES [dbo].[k_m_indicators_fields] ([id_indicator_field]),
    CONSTRAINT [FK_cm_simulation_indicator_field_accessibility_k_m_plans_indicators] FOREIGN KEY ([id_plan_indicator]) REFERENCES [dbo].[k_m_plans_indicators] ([id_plan_indicator])
);

