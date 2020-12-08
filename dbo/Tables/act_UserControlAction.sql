CREATE TABLE [dbo].[act_UserControlAction] (
    [id]           INT IDENTITY (1, 1) NOT NULL,
    [idControl]    INT NULL,
    [idAction]     INT NULL,
    [idActionType] INT NULL,
    CONSTRAINT [PK_act_UserControlAction] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_act_UserControlAction_act_Action] FOREIGN KEY ([idAction]) REFERENCES [dbo].[act_Action] ([id]),
    CONSTRAINT [FK_act_UserControlAction_act_ActionType] FOREIGN KEY ([idActionType]) REFERENCES [dbo].[act_ActionType] ([id]),
    CONSTRAINT [FK_act_UserControlAction_act_UserControl] FOREIGN KEY ([idControl]) REFERENCES [dbo].[act_UserControl] ([id])
);

