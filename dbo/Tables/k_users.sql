CREATE TABLE [dbo].[k_users] (
    [id_user]                INT              IDENTITY (1, 1) NOT NULL,
    [id_external_user]       NVARCHAR (50)    NULL,
    [firstname_user]         NVARCHAR (50)    NULL,
    [lastname_user]          NVARCHAR (50)    NULL,
    [login_user]             NVARCHAR (255)   NOT NULL,
    [domainName]             NVARCHAR (50)    NULL,
    [ldapSid]                NVARCHAR (500)   NULL,
    [ntLoginName]            NVARCHAR (50)    NULL,
    [password_user]          NVARCHAR (200)   NOT NULL,
    [isadmin_user]           BIT              CONSTRAINT [DF_k_users_isadmin_user] DEFAULT ((0)) NULL,
    [date_created_user]      SMALLDATETIME    NULL,
    [date_modified_user]     SMALLDATETIME    NULL,
    [nb_attempt_user]        INT              CONSTRAINT [DF_k_users_nb_attempt_user] DEFAULT ((0)) NULL,
    [culture_user]           CHAR (5)         CONSTRAINT [DF_k_users_culture_user] DEFAULT ('FR') NULL,
    [stylesheet_user]        INT              CONSTRAINT [DF_k_users_stylesheet_user] DEFAULT ((-1)) NULL,
    [active_user]            BIT              CONSTRAINT [DF_k_users_active_user] DEFAULT ((0)) NULL,
    [comments_user]          NVARCHAR (MAX)   NULL,
    [mail_user]              NVARCHAR (255)   NULL,
    [id_owner]               INT              NULL,
    [id_user_parameter]      INT              NULL,
    [idExternalSSO]          NVARCHAR (100)   NULL,
    [date_modified_password] SMALLDATETIME    NULL,
    [id_source_tenant]       INT              NULL,
    [id_source]              INT              NULL,
    [id_change_set]          INT              NULL,
    [sisense_id]             NVARCHAR (50)    NULL,
    [uid_user]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_k_users] PRIMARY KEY CLUSTERED ([id_user] ASC),
    CONSTRAINT [FK_k_users_k_users_parameters] FOREIGN KEY ([id_user_parameter]) REFERENCES [dbo].[k_users_parameters] ([id])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_users_firstname_user_lastname_user]
    ON [dbo].[k_users]([firstname_user] ASC, [lastname_user] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_k_users_idExternalSSO]
    ON [dbo].[k_users]([idExternalSSO] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_k_users_login_user]
    ON [dbo].[k_users]([login_user] ASC);

