CREATE TABLE [dbo].[k_m_plan_display_form_field] (
    [id_form_field]                     INT IDENTITY (1, 1) NOT NULL,
    [id_plan_display]                   INT NOT NULL,
    [id_field]                          INT NOT NULL,
    [id_form_field_type]                INT NOT NULL,
    [available_plan_display_form_field] BIT NOT NULL,
    [id_source_tenant]                  INT NULL,
    [id_source]                         INT NULL,
    [id_change_set]                     INT NULL,
    CONSTRAINT [PK_k_m_plan_display_form_field] PRIMARY KEY CLUSTERED ([id_form_field] ASC),
    CONSTRAINT [FK_k_m_plan_display_form_field_k_m_plan_display] FOREIGN KEY ([id_plan_display]) REFERENCES [dbo].[k_m_plan_display] ([id_plan_display]),
    CONSTRAINT [FK_k_m_plan_display_form_field_k_m_plan_form_content] FOREIGN KEY ([id_field]) REFERENCES [dbo].[k_m_plan_form_content] ([plan_form_field_id])
);

