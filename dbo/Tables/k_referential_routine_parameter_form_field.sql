CREATE TABLE [dbo].[k_referential_routine_parameter_form_field] (
    [id_routine_parameter_form_field] INT IDENTITY (1, 1) NOT NULL,
    [form_field_id]                   INT NOT NULL,
    [id_routine_parameter]            INT NOT NULL,
    CONSTRAINT [PK_k_referential_routine_parameter_form_field] PRIMARY KEY CLUSTERED ([id_routine_parameter_form_field] ASC),
    CONSTRAINT [FK_k_referential_routine_parameter_form_field_form_field_id] FOREIGN KEY ([form_field_id]) REFERENCES [dbo].[k_referential_form_field] ([field_id]),
    CONSTRAINT [FK_k_referential_routine_parameter_id_routine_parameter] FOREIGN KEY ([id_routine_parameter]) REFERENCES [dbo].[k_referential_routine_parameter] ([id_routine_parameter])
);

