CREATE TABLE [dbo].[k_referential_routine_form] (
    [id_routine_form] INT IDENTITY (1, 1) NOT NULL,
    [form_id]         INT NOT NULL,
    [id_routine]      INT NOT NULL,
    CONSTRAINT [PK_k_referential_routine_form] PRIMARY KEY CLUSTERED ([id_routine_form] ASC),
    CONSTRAINT [FK_k_referential_routine_form_form_id] FOREIGN KEY ([form_id]) REFERENCES [dbo].[k_referential_form] ([form_id]),
    CONSTRAINT [FK_k_referential_routine_form_id_routine] FOREIGN KEY ([id_routine]) REFERENCES [dbo].[k_referential_routine] ([id_routine])
);

