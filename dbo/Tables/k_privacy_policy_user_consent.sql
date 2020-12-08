CREATE TABLE [dbo].[k_privacy_policy_user_consent] (
    [id_privacy_policy_user_consent] INT           IDENTITY (1, 1) NOT NULL,
    [id_user]                        INT           NOT NULL,
    [id_privacy_policy]              INT           NOT NULL,
    [is_accepted]                    BIT           DEFAULT ((0)) NOT NULL,
    [creation_date]                  SMALLDATETIME NOT NULL,
    [modification_date]              SMALLDATETIME NOT NULL,
    PRIMARY KEY CLUSTERED ([id_privacy_policy_user_consent] ASC),
    CONSTRAINT [FK_k_privacy_policy_user_consent_k_privacy_policy] FOREIGN KEY ([id_privacy_policy]) REFERENCES [dbo].[k_privacy_policy] ([id_privacy_policy]),
    CONSTRAINT [FK_k_privacy_policy_user_consent_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user])
);

