CREATE TABLE [dbo].[k_versions] (
    [id_version]      INT           IDENTITY (1, 1) NOT NULL,
    [name_version]    NVARCHAR (50) NOT NULL,
    [default_version] BIT           NOT NULL,
    CONSTRAINT [PK_k_versions] PRIMARY KEY CLUSTERED ([id_version] ASC)
);

