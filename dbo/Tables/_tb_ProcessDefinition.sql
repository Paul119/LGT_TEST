CREATE TABLE [dbo].[_tb_ProcessDefinition] (
    [ProcessDefinitionId] INT  IDENTITY (1, 1) NOT NULL,
    [id_plan]             INT  NULL,
    [FreezeDate]          DATE NULL,
    [IsActive]            BIT  NULL,
    CONSTRAINT [pk_tb_ProcessDefinition_ProcessDefinitionId] PRIMARY KEY CLUSTERED ([ProcessDefinitionId] ASC)
);

