CREATE TABLE [dbo].[_tb_Profiles_Management] (
    [ProfileManagementId] INT IDENTITY (1, 1) NOT NULL,
    [id_user]             INT NOT NULL,
    [id_profile]          INT NOT NULL,
    PRIMARY KEY CLUSTERED ([ProfileManagementId] ASC)
);

