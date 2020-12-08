CREATE TABLE [dbo].[k_dashboard] (
    [id_dashboard]    INT             IDENTITY (1, 1) NOT NULL,
    [name_dashboard]  NVARCHAR (250)  NOT NULL,
    [layout]          NVARCHAR (MAX)  NULL,
    [description]     NVARCHAR (1000) NULL,
    [fullscreen_mode] BIT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_k_dashboard] PRIMARY KEY CLUSTERED ([id_dashboard] ASC)
);

