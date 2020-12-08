CREATE TABLE [dbo].[k_profiles_modules_rights] (
    [id_profile_module_right] INT      IDENTITY (1, 1) NOT NULL,
    [id_profile]              INT      NOT NULL,
    [id_module_right]         INT      NOT NULL,
    [id_source_tenant]        INT      NULL,
    [id_source]               INT      NULL,
    [id_change_set]           INT      NULL,
    [start_date]              DATETIME NULL,
    [end_date]                DATETIME NULL,
    CONSTRAINT [PK_k_profiles_modules_rights] PRIMARY KEY CLUSTERED ([id_profile_module_right] ASC),
    CONSTRAINT [FK_k_profiles_modules_rights_k_modules_rights] FOREIGN KEY ([id_module_right]) REFERENCES [dbo].[k_modules_rights] ([id_module_right]),
    CONSTRAINT [FK_k_profiles_modules_rights_k_profiles] FOREIGN KEY ([id_profile]) REFERENCES [dbo].[k_profiles] ([id_profile])
);

