CREATE TABLE [dbo].[rps_file_status] (
    [id_file_status]   INT           IDENTITY (1, 1) NOT NULL,
    [name_file_status] NVARCHAR (30) NULL,
    CONSTRAINT [PK_rps_file_status] PRIMARY KEY CLUSTERED ([id_file_status] ASC)
);

