CREATE TABLE [dbo].[k_m_values_histo] (
    [id_value]            BIGINT          NOT NULL,
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
    [source_value]        NVARCHAR (MAX)  NULL,
    [date_histo]          DATETIME        NOT NULL,
    [user_histo]          INT             NOT NULL,
    [id_histo]            INT             IDENTITY (1, 1) NOT NULL,
    [value_type]          TINYINT         NULL,
    [idSim]               INT             NULL,
    [typeModification]    INT             NULL,
    [idOrg]               INT             NULL,
    CONSTRAINT [PK_k_m_values_historique] PRIMARY KEY CLUSTERED ([id_histo] ASC)
);

