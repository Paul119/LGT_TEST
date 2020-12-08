CREATE TABLE [dbo].[act_ActionScript] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [idAction]     INT            NOT NULL,
    [redScript]    NVARCHAR (MAX) NULL,
    [processOrder] INT            NOT NULL,
    CONSTRAINT [PK_act_ActionScript] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_act_ActionScript_act_Action] FOREIGN KEY ([idAction]) REFERENCES [dbo].[act_Action] ([id])
);

