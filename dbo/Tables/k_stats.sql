CREATE TABLE [dbo].[k_stats] (
    [id_stat]        INT            IDENTITY (1, 1) NOT NULL,
    [name_stat]      NVARCHAR (MAX) NULL,
    [type_stat]      NVARCHAR (MAX) NULL,
    [id_user]        INT            NULL,
    [firstname_user] NVARCHAR (MAX) NULL,
    [lastname_user]  NVARCHAR (MAX) NULL,
    [comments_stat]  NVARCHAR (MAX) NULL,
    [username]       NVARCHAR (250) NULL,
    [idContext]      NVARCHAR (250) NULL,
    [idService]      INT            NULL,
    [idMethod]       INT            NULL,
    [requestTime]    DATETIME       NULL,
    [responseTime]   DATETIME       NULL,
    [name_method]    NVARCHAR (500) NULL,
    CONSTRAINT [PK_k_stats] PRIMARY KEY CLUSTERED ([id_stat] ASC)
);

