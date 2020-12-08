CREATE TABLE [dbo].[tb_employee_information_import_action] (
    [Id]         INT IDENTITY (1, 1) NOT NULL,
    [ImportType] INT NULL,
    [ActionId]   INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

