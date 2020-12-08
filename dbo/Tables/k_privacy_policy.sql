CREATE TABLE [dbo].[k_privacy_policy] (
    [id_privacy_policy]                INT           IDENTITY (1, 1) NOT NULL,
    [creation_date]                    SMALLDATETIME NOT NULL,
    [is_custom_privacy_policy_enabled] BIT           DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([id_privacy_policy] ASC)
);

