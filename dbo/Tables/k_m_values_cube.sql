CREATE TABLE [dbo].[k_m_values_cube] (
    [id_value_cube]    BIGINT         IDENTITY (1, 1) NOT NULL,
    [id_ind]           INT            NOT NULL,
    [id_field]         INT            NOT NULL,
    [id_step]          INT            NOT NULL,
    [id_perimeter]     INT            NOT NULL,
    [input_value_cube] NVARCHAR (MAX) NULL,
    [source_value]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_m_values_cube_1] PRIMARY KEY CLUSTERED ([id_value_cube] ASC)
);

