CREATE TABLE [dbo].[act_ActionType] (
    [id]   INT           IDENTITY (1, 1) NOT NULL,
    [name] NVARCHAR (25) NOT NULL,
    CONSTRAINT [PK_act_ActionType] PRIMARY KEY CLUSTERED ([id] ASC)
);

