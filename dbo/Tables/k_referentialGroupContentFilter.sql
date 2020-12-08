CREATE TABLE [dbo].[k_referentialGroupContentFilter] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [groupContentId] INT            NULL,
    [source]         NVARCHAR (100) NULL,
    [destination]    NVARCHAR (100) NULL,
    [isKernel]       BIT            NULL,
    CONSTRAINT [PK__k_refere__3213E83F444B1483] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_referentialGroupContentFilter_k_referentialGroupContent] FOREIGN KEY ([groupContentId]) REFERENCES [dbo].[k_referentialGroupContent] ([id])
);

