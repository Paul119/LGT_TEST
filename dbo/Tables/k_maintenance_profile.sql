CREATE TABLE [dbo].[k_maintenance_profile] (
    [id_maintenance_profile] INT IDENTITY (1, 1) NOT NULL,
    [id_maintenance]         INT NOT NULL,
    [id_profile]             INT NOT NULL,
    CONSTRAINT [PK_k_maintenance_profile] PRIMARY KEY CLUSTERED ([id_maintenance_profile] ASC),
    CONSTRAINT [FK_k_maintenance_profile_k_maintenance] FOREIGN KEY ([id_maintenance]) REFERENCES [dbo].[k_maintenance] ([id_maintenance]),
    CONSTRAINT [FK_k_maintenance_profile_k_profiles] FOREIGN KEY ([id_profile]) REFERENCES [dbo].[k_profiles] ([id_profile])
);

