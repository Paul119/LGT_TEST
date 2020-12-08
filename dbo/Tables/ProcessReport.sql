CREATE TABLE [dbo].[ProcessReport] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [name]       NVARCHAR (50) NULL,
    [type]       TINYINT       NULL,
    [idProcess]  INT           NULL,
    [showLegend] BIT           NULL,
    [width]      SMALLINT      NULL,
    [height]     SMALLINT      NULL,
    [backColor]  VARCHAR (8)   NULL,
    [createDate] DATETIME      NULL,
    [createdBy]  INT           NULL,
    CONSTRAINT [PK_ProcessReport] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ProcessReport_k_m_plans] FOREIGN KEY ([idProcess]) REFERENCES [dbo].[k_m_plans] ([id_plan])
);

