CREATE TABLE [dbo].[k_m_plans_informations] (
    [id_planInfo]      INT IDENTITY (1, 1) NOT NULL,
    [id_plan]          INT NOT NULL,
    [id_field_grid]    INT NULL,
    [width]            INT CONSTRAINT [DF_k_m_plans_informations_width] DEFAULT ((0)) NOT NULL,
    [sort]             INT CONSTRAINT [DF_k_m_plans_informations_sort] DEFAULT ((0)) NOT NULL,
    [is_locked]        BIT NULL,
    [id_source_tenant] INT NULL,
    [id_source]        INT NULL,
    [id_change_set]    INT NULL,
    [type]             INT DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_k_m_plans_informations] PRIMARY KEY CLUSTERED ([id_planInfo] ASC),
    CONSTRAINT [FK_k_m_plans_informations_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_k_m_plans_informations_k_referential_grids_fields] FOREIGN KEY ([id_field_grid]) REFERENCES [dbo].[k_referential_grids_fields] ([id_column])
);

