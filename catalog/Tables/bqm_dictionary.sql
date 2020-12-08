CREATE TABLE [catalog].[bqm_dictionary] (
    [uid_dictionary_key] UNIQUEIDENTIFIER NOT NULL,
    [value]              INT              NOT NULL,
    [display_text]       NVARCHAR (500)   NULL,
    [uid_user_create]    UNIQUEIDENTIFIER NOT NULL,
    [date_create]        DATETIME         NOT NULL,
    CONSTRAINT [PK_bqm_dictionary] PRIMARY KEY CLUSTERED ([uid_dictionary_key] ASC)
);

