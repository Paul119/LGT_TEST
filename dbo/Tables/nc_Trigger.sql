CREATE TABLE [dbo].[nc_Trigger] (
    [id]     INT            IDENTITY (1, 1) NOT NULL,
    [name]   NVARCHAR (200) NULL,
    [idType] INT            NULL,
    CONSTRAINT [PK_k_m_Module] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_nc_Trigger_nc_Type] FOREIGN KEY ([idType]) REFERENCES [dbo].[nc_Type] ([id])
);

