CREATE TABLE [dbo].[k_user_plan_field_view] (
    [id_user_plan_field_view]  INT            IDENTITY (1, 1) NOT NULL,
    [id_user_plan_view]        INT            NOT NULL,
    [id_plan_information]      INT            NULL,
    [id_indicator_field]       INT            NULL,
    [column_name]              NVARCHAR (250) NULL,
    [sort]                     INT            NULL,
    [sort_direction]           INT            NULL,
    [is_visible]               BIT            CONSTRAINT [DF_k_user_plan_field_view_is_visible] DEFAULT ((0)) NOT NULL,
    [filter_type]              INT            NULL,
    [filter_value]             NVARCHAR (MAX) NULL,
    [width]                    INT            NULL,
    [order_columns]            INT            NULL,
    [is_frozen]                BIT            NULL,
    [indicator_field_sub_type] NVARCHAR (10)  NULL,
    [is_grouped]               BIT            NULL,
    CONSTRAINT [PK_k_user_plan_field_view] PRIMARY KEY CLUSTERED ([id_user_plan_field_view] ASC),
    CONSTRAINT [FK_k_user_plan_field_view_k_m_indicators_fields] FOREIGN KEY ([id_indicator_field]) REFERENCES [dbo].[k_m_indicators_fields] ([id_indicator_field]),
    CONSTRAINT [FK_k_user_plan_field_view_k_m_plans_informations] FOREIGN KEY ([id_plan_information]) REFERENCES [dbo].[k_m_plans_informations] ([id_planInfo]),
    CONSTRAINT [FK_k_user_plan_field_view_k_user_plan_view] FOREIGN KEY ([id_user_plan_view]) REFERENCES [dbo].[k_user_plan_view] ([id_user_plan_view])
);

