CREATE TABLE [dbo].[k_referential_routine_parameter] (
    [id_routine_parameter]   INT            IDENTITY (1, 1) NOT NULL,
    [id_routine]             INT            NOT NULL,
    [name_routine_parameter] NVARCHAR (MAX) NOT NULL,
    [dynamic_value_type]     TINYINT        NULL,
    [static_value]           NVARCHAR (250) NULL,
    [type_routine_parameter] NVARCHAR (20)  NOT NULL,
    CONSTRAINT [PK_k_referential_routine_parameter] PRIMARY KEY CLUSTERED ([id_routine_parameter] ASC),
    CONSTRAINT [FK_k_referential_routine_parameter_default_value_type_default_value_dynamic] FOREIGN KEY ([dynamic_value_type]) REFERENCES [dbo].[k_referential_routine_parameter_dynamic_value_type] ([id_routine_parameter_dynamic_value_type]),
    CONSTRAINT [FK_k_referential_routine_parameter_id_routine] FOREIGN KEY ([id_routine]) REFERENCES [dbo].[k_referential_routine] ([id_routine])
);

