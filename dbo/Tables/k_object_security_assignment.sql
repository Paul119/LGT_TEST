CREATE TABLE [dbo].[k_object_security_assignment] (
    [id_object_security_assignment] INT IDENTITY (1, 1) NOT NULL,
    [id_user]                       INT NULL,
    [id_profile]                    INT NULL,
    [id_team]                       INT NULL,
    [id_object_security]            INT NOT NULL,
    CONSTRAINT [PK_k_object_security_assignment] PRIMARY KEY CLUSTERED ([id_object_security_assignment] ASC),
    CONSTRAINT [FK_k_object_security_assignment_k_object_security] FOREIGN KEY ([id_object_security]) REFERENCES [dbo].[k_object_security] ([id_object_security]) ON DELETE CASCADE,
    CONSTRAINT [FK_k_object_security_assignment_k_profiles] FOREIGN KEY ([id_profile]) REFERENCES [dbo].[k_profiles] ([id_profile]) ON DELETE CASCADE,
    CONSTRAINT [FK_k_object_security_assignment_k_teams] FOREIGN KEY ([id_team]) REFERENCES [dbo].[k_teams] ([id_team]) ON DELETE CASCADE,
    CONSTRAINT [FK_k_object_security_assignment_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user]) ON DELETE CASCADE
);

