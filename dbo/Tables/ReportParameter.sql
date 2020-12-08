CREATE TABLE [dbo].[ReportParameter] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [idProcessReport] INT           NULL,
    [idProcess]       INT           NULL,
    [idIndicator]     INT           NULL,
    [idField]         INT           NULL,
    [typeAction]      TINYINT       NULL,
    [nameParameter]   NVARCHAR (50) NULL,
    [xIndex]          TINYINT       NULL,
    [yIndex]          TINYINT       NULL,
    [zIndex]          TINYINT       NULL,
    CONSTRAINT [PK_ReportParameter] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ReportParameter_ProcessReport] FOREIGN KEY ([idProcessReport]) REFERENCES [dbo].[ProcessReport] ([id])
);

