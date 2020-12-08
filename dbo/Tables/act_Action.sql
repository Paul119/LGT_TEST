CREATE TABLE [dbo].[act_Action] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [name]        NVARCHAR (50)  NOT NULL,
    [description] NVARCHAR (250) NULL,
    [help_text]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_act_Action] PRIMARY KEY CLUSTERED ([id] ASC)
);

