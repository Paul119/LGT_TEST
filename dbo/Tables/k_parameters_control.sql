CREATE TABLE [dbo].[k_parameters_control] (
    [id_control]    INT            IDENTITY (1, 1) NOT NULL,
    [name_control]  NVARCHAR (MAX) NULL,
    [name_table]    NVARCHAR (50)  NULL,
    [value_field]   NVARCHAR (50)  NULL,
    [display_field] NVARCHAR (50)  NULL,
    CONSTRAINT [PK_k_parameters_control_type] PRIMARY KEY CLUSTERED ([id_control] ASC)
);

