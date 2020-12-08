CREATE TABLE [dbo].[nc_Variables] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [idType]      INT           NULL,
    [idTrigger]   INT           NULL,
    [name]        VARCHAR (500) NULL,
    [aggregation] BIT           CONSTRAINT [DF_nc_Variables_aggregation] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_nc_ModuleParameters] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_nc_Variables_nc_Trigger] FOREIGN KEY ([idTrigger]) REFERENCES [dbo].[nc_Trigger] ([id]),
    CONSTRAINT [FK_nc_Variables_nc_Type] FOREIGN KEY ([idType]) REFERENCES [dbo].[nc_Type] ([id])
);

