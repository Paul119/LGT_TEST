CREATE TABLE [dbo].[_tb_etl_passport_temp] (
    [ID]           INT            NULL,
    [PassportID]   NVARCHAR (50)  NULL,
    [LoginName]    NVARCHAR (50)  NULL,
    [ExternalID]   NVARCHAR (10)  NULL,
    [PassportName] NVARCHAR (255) NULL,
    [Email]        NVARCHAR (255) NULL,
    [active_user]  BIT            NULL
);

