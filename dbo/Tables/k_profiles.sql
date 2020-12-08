CREATE TABLE [dbo].[k_profiles] (
    [id_profile]         INT              IDENTITY (1, 1) NOT NULL,
    [name_profile]       NVARCHAR (50)    NOT NULL,
    [comments_profile]   NVARCHAR (MAX)   NULL,
    [id_owner]           INT              NULL,
    [date_created]       SMALLDATETIME    NULL,
    [date_last_modified] SMALLDATETIME    NULL,
    [id_source_tenant]   INT              NULL,
    [id_source]          INT              NULL,
    [id_change_set]      INT              NULL,
    [id_home_page]       INT              CONSTRAINT [DF_k_profiles_id_home_page] DEFAULT ((-1)) NOT NULL,
    [id_module_landing]  INT              NOT NULL,
    [access_ui]          TINYINT          DEFAULT ((1)) NULL,
    [sisense_id]         NVARCHAR (50)    NULL,
    [default_ui]         TINYINT          DEFAULT ((2)) NOT NULL,
    [uid_profile]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_k_profile] PRIMARY KEY CLUSTERED ([id_profile] ASC),
    CONSTRAINT [FK_k_profiles_k_home_page] FOREIGN KEY ([id_home_page]) REFERENCES [dbo].[k_home_page] ([id_home_page]),
    CONSTRAINT [FK_k_profiles_k_modules] FOREIGN KEY ([id_module_landing]) REFERENCES [dbo].[k_modules] ([id_module]),
    CONSTRAINT [FK_k_profiles_k_profiles_access_ui] FOREIGN KEY ([access_ui]) REFERENCES [dbo].[k_profiles_access_ui] ([id_profile_access_ui])
);

