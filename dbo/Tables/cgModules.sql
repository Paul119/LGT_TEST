CREATE TABLE [dbo].[cgModules] (
    [id_modules]      INT           IDENTITY (1, 1) NOT NULL,
    [name_modules]    NVARCHAR (20) NOT NULL,
    [id_real_modules] INT           NOT NULL,
    CONSTRAINT [PK_cgModules] PRIMARY KEY CLUSTERED ([id_modules] ASC),
    CONSTRAINT [FK_cgModules_k_modules] FOREIGN KEY ([id_real_modules]) REFERENCES [dbo].[k_modules] ([id_module])
);

