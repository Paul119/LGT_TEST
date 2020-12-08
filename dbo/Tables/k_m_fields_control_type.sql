CREATE TABLE [dbo].[k_m_fields_control_type] (
    [id_control_type]    INT            IDENTITY (1, 1) NOT NULL,
    [name_control_type]  NVARCHAR (255) NOT NULL,
    [value_control_type] NVARCHAR (255) NOT NULL,
    [sort_control_type]  INT            NOT NULL,
    CONSTRAINT [PK_k_m_fields_control_type] PRIMARY KEY CLUSTERED ([id_control_type] ASC)
);

