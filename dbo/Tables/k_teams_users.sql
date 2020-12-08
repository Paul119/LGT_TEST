CREATE TABLE [dbo].[k_teams_users] (
    [idTeamsUsers]     INT IDENTITY (1, 1) NOT NULL,
    [id_team]          INT NOT NULL,
    [id_user]          INT NOT NULL,
    [id_source_tenant] INT NULL,
    [id_source]        INT NULL,
    [id_change_set]    INT NULL,
    CONSTRAINT [PK_k_teams_users] PRIMARY KEY CLUSTERED ([idTeamsUsers] ASC),
    CONSTRAINT [FK_k_teams_users_k_teams] FOREIGN KEY ([id_team]) REFERENCES [dbo].[k_teams] ([id_team]),
    CONSTRAINT [FK_k_teams_users_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user])
);

