CREATE TABLE [dbo].[k_user_plan_field_setting] (
    [id_user_plan_field_setting] INT            IDENTITY (1, 1) NOT NULL,
    [id_type_field_setting]      INT            CONSTRAINT [DF_k_user_plan_field_setting_id_type_field_setting] DEFAULT ((-1)) NOT NULL,
    [name_field_setting]         NVARCHAR (MAX) NOT NULL,
    [id_plan]                    INT            NOT NULL,
    [id_user_profile]            INT            NOT NULL,
    [is_selected]                BIT            CONSTRAINT [DF_k_user_plan_field_setting_is_selected] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_k_user_plan_field_setting] PRIMARY KEY CLUSTERED ([id_user_plan_field_setting] ASC),
    CONSTRAINT [FK_k_user_plan_field_setting_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_k_user_plan_field_setting_k_users_profiles] FOREIGN KEY ([id_user_profile]) REFERENCES [dbo].[k_users_profiles] ([idUserProfile])
);

