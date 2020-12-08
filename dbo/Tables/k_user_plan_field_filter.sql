CREATE TABLE [dbo].[k_user_plan_field_filter] (
    [id_user_plan_field_filter]  INT            IDENTITY (1, 1) NOT NULL,
    [id_user_plan_field_setting] INT            NOT NULL,
    [column_name]                NVARCHAR (250) NULL,
    [id_plan_information]        INT            NULL,
    [id_indicator_field]         INT            NULL,
    [filter_type]                INT            NOT NULL,
    [filter_value]               NVARCHAR (250) NOT NULL,
    CONSTRAINT [PK_k_user_plan_field_filter] PRIMARY KEY CLUSTERED ([id_user_plan_field_filter] ASC),
    CONSTRAINT [FK_k_user_plan_field_filter_k_column_filter_type] FOREIGN KEY ([filter_type]) REFERENCES [dbo].[k_column_filter_type] ([id_column_filter_type]),
    CONSTRAINT [FK_k_user_plan_field_filter_k_m_indicators_fields] FOREIGN KEY ([id_indicator_field]) REFERENCES [dbo].[k_m_indicators_fields] ([id_indicator_field]),
    CONSTRAINT [FK_k_user_plan_field_filter_k_m_plans_informations] FOREIGN KEY ([id_plan_information]) REFERENCES [dbo].[k_m_plans_informations] ([id_planInfo]),
    CONSTRAINT [FK_k_user_plan_field_filter_k_user_plan_field_setting] FOREIGN KEY ([id_user_plan_field_setting]) REFERENCES [dbo].[k_user_plan_field_setting] ([id_user_plan_field_setting])
);

