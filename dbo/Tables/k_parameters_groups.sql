CREATE TABLE [dbo].[k_parameters_groups] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [groupHeader] NVARCHAR (50) NULL,
    [sort]        INT           NULL,
    CONSTRAINT [PK_k_parameters_groups] PRIMARY KEY CLUSTERED ([id] ASC)
);

