CREATE TABLE [dbo].[cm_rule_executionresult] (
    [idExecutionResult] INT            IDENTITY (1, 1) NOT NULL,
    [idProcess]         INT            NULL,
    [idSimulaiton]      INT            NULL,
    [idRule]            INT            NULL,
    [idUser]            INT            NULL,
    [ResultExecution]   NVARCHAR (MAX) NULL,
    [StartDate]         DATETIME       NULL,
    [EndDate]           DATETIME       NULL,
    CONSTRAINT [PK_cm_rule_executionresult] PRIMARY KEY CLUSTERED ([idExecutionResult] ASC)
);

