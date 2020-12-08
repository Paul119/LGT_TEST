CREATE TABLE [dbo].[k_teams] (
    [id_team]            INT            IDENTITY (1, 1) NOT NULL,
    [name_team]          NVARCHAR (50)  NULL,
    [comments_team]      NVARCHAR (MAX) NULL,
    [id_owner]           INT            NULL,
    [date_created]       SMALLDATETIME  NULL,
    [date_last_modified] SMALLDATETIME  NULL,
    [id_source_tenant]   INT            NULL,
    [id_source]          INT            NULL,
    [id_change_set]      INT            NULL,
    CONSTRAINT [PK_k_teams] PRIMARY KEY CLUSTERED ([id_team] ASC)
);

