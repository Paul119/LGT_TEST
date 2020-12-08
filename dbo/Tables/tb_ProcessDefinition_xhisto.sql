CREATE TABLE [dbo].[tb_ProcessDefinition_xhisto] (
    [id_xhisto]           INT      IDENTITY (1, 1) NOT NULL,
    [id_user_xhisto]      INT      NOT NULL,
    [dt_xhisto]           DATETIME NOT NULL,
    [type_xhisto]         CHAR (3) NOT NULL,
    [FreezeDate]          DATE     NULL,
    [id_plan]             INT      NULL,
    [IsActive]            BIT      NULL,
    [ProcessDefinitionId] INT      NULL,
    PRIMARY KEY CLUSTERED ([id_xhisto] ASC)
);

