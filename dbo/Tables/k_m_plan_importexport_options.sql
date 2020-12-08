CREATE TABLE [dbo].[k_m_plan_importexport_options] (
    [id_plan_importexport_options] INT           IDENTITY (1, 1) NOT NULL,
    [name]                         NVARCHAR (50) NULL,
    CONSTRAINT [PK_k_m_plan_importexport_options] PRIMARY KEY CLUSTERED ([id_plan_importexport_options] ASC)
);

