CREATE TABLE [dbo].[k_teams_shares] (
    [id_team_share]    INT      IDENTITY (1, 1) NOT NULL,
    [id_team]          INT      NOT NULL,
    [id_share]         INT      NOT NULL,
    [id_object]        INT      NOT NULL,
    [start_date]       DATETIME NULL,
    [end_date]         DATETIME NULL,
    [id_source_tenant] INT      NULL,
    [id_source]        INT      NULL,
    [id_change_set]    INT      NULL,
    CONSTRAINT [PK_k_teams_profiles] PRIMARY KEY CLUSTERED ([id_team_share] ASC),
    CONSTRAINT [FK_k_teams_shares_k_modules_shares_rights] FOREIGN KEY ([id_share]) REFERENCES [dbo].[k_modules_shares_rights] ([id_share]),
    CONSTRAINT [FK_k_teams_shares_k_teams] FOREIGN KEY ([id_team]) REFERENCES [dbo].[k_teams] ([id_team])
);

