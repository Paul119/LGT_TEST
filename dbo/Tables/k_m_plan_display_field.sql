CREATE TABLE [dbo].[k_m_plan_display_field] (
    [id_plan_display_field]            INT IDENTITY (1, 1) NOT NULL,
    [id_plan_display]                  INT NOT NULL,
    [id_indicator_field]               INT NOT NULL,
    [available_plan_display_field]     BIT NOT NULL,
    [show_plan_display_field]          BIT NOT NULL,
    [optional_show_plan_display_field] BIT NOT NULL,
    [id_source_tenant]                 INT NULL,
    [id_source]                        INT NULL,
    [id_change_set]                    INT NULL,
    [filter_order]                     INT NULL,
    CONSTRAINT [PK_k_m_plan_display_field] PRIMARY KEY CLUSTERED ([id_plan_display_field] ASC),
    CONSTRAINT [FK_k_m_plan_display_field_k_m_indicators_fields] FOREIGN KEY ([id_indicator_field]) REFERENCES [dbo].[k_m_indicators_fields] ([id_indicator_field]),
    CONSTRAINT [FK_k_m_plan_display_field_k_m_plan_display] FOREIGN KEY ([id_plan_display]) REFERENCES [dbo].[k_m_plan_display] ([id_plan_display])
);

