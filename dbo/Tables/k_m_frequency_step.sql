CREATE TABLE [dbo].[k_m_frequency_step] (
    [id_frequency_step] INT IDENTITY (1, 1) NOT NULL,
    [index]             INT NOT NULL,
    [number_of_days]    INT NOT NULL,
    [is_included]       BIT NOT NULL,
    [id_frequency]      INT NOT NULL,
    [id_source_tenant]  INT NULL,
    [id_source]         INT NULL,
    [id_change_set]     INT NULL,
    CONSTRAINT [PK_k_m_frequency_step] PRIMARY KEY CLUSTERED ([id_frequency_step] ASC),
    CONSTRAINT [FK_k_m_frequency_step_k_m_frequency] FOREIGN KEY ([id_frequency]) REFERENCES [dbo].[k_m_frequency] ([id_frequency])
);

