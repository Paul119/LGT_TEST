CREATE TABLE [dbo].[k_profile_module_display] (
    [id_profile_module_display] INT IDENTITY (1, 1) NOT NULL,
    [id_profile]                INT NOT NULL,
    [id_module]                 INT NOT NULL,
    CONSTRAINT [PK_k_profile_module_display] PRIMARY KEY CLUSTERED ([id_profile_module_display] ASC),
    CONSTRAINT [FK_k_profile_module_display_k_modules] FOREIGN KEY ([id_module]) REFERENCES [dbo].[k_modules] ([id_module]),
    CONSTRAINT [FK_k_profile_module_display_k_profiles] FOREIGN KEY ([id_profile]) REFERENCES [dbo].[k_profiles] ([id_profile])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UQ_k_profile_module_display_id_profile_id_module]
    ON [dbo].[k_profile_module_display]([id_profile] ASC, [id_module] ASC);

