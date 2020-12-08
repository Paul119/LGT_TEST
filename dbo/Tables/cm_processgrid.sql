CREATE TABLE [dbo].[cm_processgrid] (
    [id_processgrid] INT           IDENTITY (1, 1) NOT NULL,
    [id_grid]        INT           NULL,
    [id_process]     INT           NULL,
    [name_grid]      NVARCHAR (50) NULL,
    CONSTRAINT [PK_cm_processgrid] PRIMARY KEY CLUSTERED ([id_processgrid] ASC),
    CONSTRAINT [FK_cm_processgrid_k_m_plans] FOREIGN KEY ([id_process]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_cm_processgrid_k_referential_grids] FOREIGN KEY ([id_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid])
);

