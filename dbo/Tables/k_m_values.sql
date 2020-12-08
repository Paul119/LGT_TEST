CREATE TABLE [dbo].[k_m_values] (
    [id_value]            BIGINT          IDENTITY (1, 1) NOT NULL,
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
    [value_type]          TINYINT         CONSTRAINT [DF_k_m_values_value_type] DEFAULT ((1)) NOT NULL,
    [idSim]               INT             CONSTRAINT [DF_k_m_values_idSim] DEFAULT ((0)) NOT NULL,
    [idOrg]               INT             NULL,
    [typeModification]    INT             NULL,
    CONSTRAINT [PK_k_m_values] PRIMARY KEY CLUSTERED ([id_value] ASC),
    CONSTRAINT [FK_k_m_values_k_m_plans_payees_steps] FOREIGN KEY ([id_step]) REFERENCES [dbo].[k_m_plans_payees_steps] ([id_step])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_values_idSim_idOrg]
    ON [dbo].[k_m_values]([idSim] ASC, [idOrg] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_k_m_values]
    ON [dbo].[k_m_values]([id_field] ASC, [id_step] ASC, [id_ind] ASC, [idSim] ASC);

