CREATE TABLE [dbo].[tb_GlobalSettings] (
    [ParameterId] INT           IDENTITY (1, 1) NOT NULL,
    [Parameter]   NVARCHAR (50) NOT NULL,
    [TextValue]   NVARCHAR (10) NULL,
    CONSTRAINT [pk_tb_GlobalSettings_ParameterId] PRIMARY KEY CLUSTERED ([ParameterId] ASC)
);

