CREATE TABLE [dbo].[k_tqm_template_step] (
    [id_template_step]        INT            IDENTITY (1, 1) NOT NULL,
    [name_template_step]      NVARCHAR (200) NULL,
    [id_template]             INT            NULL,
    [parent_id_template_step] INT            NULL,
    CONSTRAINT [PK_k_tqm_template_step] PRIMARY KEY CLUSTERED ([id_template_step] ASC),
    CONSTRAINT [FK_k_tqm_template_step_k_tqm_template] FOREIGN KEY ([id_template]) REFERENCES [dbo].[k_tqm_template] ([id_template]),
    CONSTRAINT [FK_k_tqm_template_step_k_tqm_template_step] FOREIGN KEY ([parent_id_template_step]) REFERENCES [dbo].[k_tqm_template_step] ([id_template_step])
);

