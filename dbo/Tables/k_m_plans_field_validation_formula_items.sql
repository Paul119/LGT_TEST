CREATE TABLE [dbo].[k_m_plans_field_validation_formula_items] (
    [id_plans_field_validation_formula_item] INT IDENTITY (1, 1) NOT NULL,
    [id_plans_field_validation]              INT NOT NULL,
    [id_indicator_field]                     INT NULL,
    [id_planInfo]                            INT NULL,
    CONSTRAINT [PK_k_m_plans_field_validation_formula_items] PRIMARY KEY CLUSTERED ([id_plans_field_validation_formula_item] ASC),
    CONSTRAINT [FK_k_m_plans_field_validation_formula_items_k_m_plans_field_validation] FOREIGN KEY ([id_plans_field_validation]) REFERENCES [dbo].[k_m_plans_field_validation] ([id_plans_field_validation]),
    CONSTRAINT [FK_planFieldValidationFormulaItems_indFields] FOREIGN KEY ([id_indicator_field]) REFERENCES [dbo].[k_m_indicators_fields] ([id_indicator_field]),
    CONSTRAINT [FK_planFieldValidationFormulaItems_plansInformations] FOREIGN KEY ([id_planInfo]) REFERENCES [dbo].[k_m_plans_informations] ([id_planInfo])
);

