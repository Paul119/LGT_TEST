CREATE TABLE [dbo].[k_m_plans_appraisal] (
    [id_appraisal]   INT           IDENTITY (1, 1) NOT NULL,
    [name_appraisal] NVARCHAR (50) NULL,
    CONSTRAINT [PK_k_m_plans_appraisal] PRIMARY KEY CLUSTERED ([id_appraisal] ASC)
);

