CREATE TABLE [dbo].[k_tqm_template_step_dimension] (
    [id_template_step_dimension] INT IDENTITY (1, 1) NOT NULL,
    [id_template_step]           INT NULL,
    [id_dimension]               INT NULL,
    [show_on_row]                BIT NULL,
    CONSTRAINT [PK_k_tqm_template_step_dimension] PRIMARY KEY CLUSTERED ([id_template_step_dimension] ASC),
    CONSTRAINT [FK_k_tqm_template_step_dimension_k_m_olap_references] FOREIGN KEY ([id_dimension]) REFERENCES [dbo].[k_m_olap_references] ([id_reference]),
    CONSTRAINT [FK_k_tqm_template_step_dimension_k_tqm_template_step] FOREIGN KEY ([id_template_step]) REFERENCES [dbo].[k_tqm_template_step] ([id_template_step])
);

