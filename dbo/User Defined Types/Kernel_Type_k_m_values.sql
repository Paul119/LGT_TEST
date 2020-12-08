CREATE TYPE [dbo].[Kernel_Type_k_m_values] AS TABLE (
    [id_ind]              INT             NULL,
    [id_field]            INT             NULL,
    [id_step]             INT             NULL,
    [input_value]         NVARCHAR (MAX)  NULL,
    [input_value_int]     INT             NULL,
    [input_value_numeric] NUMERIC (18, 4) NULL,
    [input_value_date]    DATETIME        NULL,
    [input_date]          DATETIME        NULL,
    [id_user]             INT             NULL,
    [comment_value]       NVARCHAR (MAX)  NULL,
    [source_value]        NVARCHAR (MAX)  NULL);

