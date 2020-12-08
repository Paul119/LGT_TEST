CREATE TABLE [dbo].[act_UserControl] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [idHolder]   INT           NOT NULL,
    [controlKey] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_act_UserControl] PRIMARY KEY CLUSTERED ([id] ASC)
);

