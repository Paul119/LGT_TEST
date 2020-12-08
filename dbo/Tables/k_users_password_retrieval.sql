CREATE TABLE [dbo].[k_users_password_retrieval] (
    [id]            INT              IDENTITY (1, 1) NOT NULL,
    [retrieval_key] UNIQUEIDENTIFIER NOT NULL,
    [id_user]       INT              NOT NULL,
    [create_date]   SMALLDATETIME    NOT NULL,
    [is_active]     BIT              NOT NULL,
    CONSTRAINT [PK_k_user_password_retrieval] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_users_password_retrieval_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user])
);

