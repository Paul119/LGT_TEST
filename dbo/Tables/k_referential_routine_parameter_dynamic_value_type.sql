CREATE TABLE [dbo].[k_referential_routine_parameter_dynamic_value_type] (
    [id_routine_parameter_dynamic_value_type]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [name_routine_parameter_dynamic_value_type] NVARCHAR (25) NOT NULL,
    CONSTRAINT [PK_k_referential_routine_parameter_dynamic_value_type] PRIMARY KEY CLUSTERED ([id_routine_parameter_dynamic_value_type] ASC)
);

