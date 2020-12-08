CREATE TABLE [dbo].[k_users_password] (
    [id_changed_password]   INT            IDENTITY (1, 1) NOT NULL,
    [id_user]               NVARCHAR (50)  NOT NULL,
    [password]              NVARCHAR (100) NOT NULL,
    [date_changed_password] SMALLDATETIME  NOT NULL,
    CONSTRAINT [PK_k_users_password] PRIMARY KEY CLUSTERED ([id_changed_password] ASC)
);

