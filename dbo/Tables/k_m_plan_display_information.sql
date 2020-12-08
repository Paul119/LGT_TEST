CREATE TABLE [dbo].[k_m_plan_display_information] (
    [id_plan_display_information]            INT IDENTITY (1, 1) NOT NULL,
    [id_plan_display]                        INT NOT NULL,
    [id_plan_information]                    INT NOT NULL,
    [available_plan_display_information]     BIT NOT NULL,
    [show_plan_display_information]          BIT NOT NULL,
    [optional_show_plan_display_information] BIT NOT NULL,
    [id_source_tenant]                       INT NULL,
    [id_source]                              INT NULL,
    [id_change_set]                          INT NULL,
    [filter_order]                           INT NULL,
    CONSTRAINT [PK_k_m_plan_display_information] PRIMARY KEY CLUSTERED ([id_plan_display_information] ASC),
    CONSTRAINT [FK_k_m_plan_display_information_k_m_plan_display] FOREIGN KEY ([id_plan_display]) REFERENCES [dbo].[k_m_plan_display] ([id_plan_display]),
    CONSTRAINT [FK_k_m_plan_display_information_k_m_plans_informations] FOREIGN KEY ([id_plan_information]) REFERENCES [dbo].[k_m_plans_informations] ([id_planInfo])
);

