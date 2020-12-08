CREATE TABLE [dbo].[rps_file_source] (
    [id_file_source]     INT            IDENTITY (1, 1) NOT NULL,
    [file_location]      VARCHAR (4)    NULL,
    [template_path]      NVARCHAR (MAX) NULL,
    [extension]          VARCHAR (4)    NULL,
    [create_date]        SMALLDATETIME  NULL,
    [template_file_name] NVARCHAR (200) NULL,
    [id_owner]           INT            NULL,
    CONSTRAINT [PK_rps_file_source] PRIMARY KEY CLUSTERED ([id_file_source] ASC)
);

