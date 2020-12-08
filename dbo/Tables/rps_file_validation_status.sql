CREATE TABLE [dbo].[rps_file_validation_status] (
    [id_file_validation_status]   INT            IDENTITY (1, 1) NOT NULL,
    [name_file_validation_status] NVARCHAR (100) NULL,
    CONSTRAINT [PK_rps_file_validation_status] PRIMARY KEY CLUSTERED ([id_file_validation_status] ASC)
);

