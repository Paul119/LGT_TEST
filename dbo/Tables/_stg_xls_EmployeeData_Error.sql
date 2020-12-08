CREATE TABLE [dbo].[_stg_xls_EmployeeData_Error] (
    [ErrorId]         INT            IDENTITY (1, 1) NOT NULL,
    [PersonnelNumber] NVARCHAR (255) NULL,
    [Name]            NVARCHAR (255) NULL,
    [FirstName]       NVARCHAR (255) NULL,
    [BirthDate]       NVARCHAR (255) NULL,
    [Gender]          NVARCHAR (255) NULL,
    [EntryDate]       NVARCHAR (255) NULL,
    [LeavingDate]     NVARCHAR (255) NULL,
    [Adress]          NVARCHAR (255) NULL,
    [PostalCode]      NVARCHAR (255) NULL,
    [City]            NVARCHAR (255) NULL,
    [Canton]          NVARCHAR (255) NULL,
    [Country]         NVARCHAR (255) NULL,
    [EmployeeClass]   NVARCHAR (255) NULL,
    [EMailAddress]    NVARCHAR (255) NULL,
    [Infotext]        NVARCHAR (255) NULL,
    [ErrorMessage]    NVARCHAR (500) NULL,
    [ParentId]        INT            DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tbl_EmployeeData_Error_ID] PRIMARY KEY CLUSTERED ([ErrorId] ASC)
);

