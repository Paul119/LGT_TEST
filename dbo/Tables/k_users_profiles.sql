CREATE TABLE [dbo].[k_users_profiles] (
    [idUserProfile]    INT IDENTITY (1, 1) NOT NULL,
    [id_user]          INT NOT NULL,
    [id_profile]       INT NOT NULL,
    [id_source_tenant] INT NULL,
    [id_source]        INT NULL,
    [id_change_set]    INT NULL,
    CONSTRAINT [PK_k_users_profiles] PRIMARY KEY CLUSTERED ([idUserProfile] ASC),
    CONSTRAINT [FK_k_users_profiles_k_profiles] FOREIGN KEY ([id_profile]) REFERENCES [dbo].[k_profiles] ([id_profile])
);

