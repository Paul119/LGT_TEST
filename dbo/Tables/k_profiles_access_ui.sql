CREATE TABLE [dbo].[k_profiles_access_ui] (
    [id_profile_access_ui] TINYINT       IDENTITY (1, 1) NOT NULL,
    [name_access_ui]       NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_k_profiles_access_ui] PRIMARY KEY CLUSTERED ([id_profile_access_ui] ASC)
);

