CREATE TABLE [dbo].[rps_fileHisto] (
    [id_xhisto]            INT            IDENTITY (1, 1) NOT NULL,
    [id_user_xhisto]       INT            NULL,
    [type_xhisto]          VARCHAR (10)   NULL,
    [change_date_xhisto]   SMALLDATETIME  NULL,
    [id_file]              INT            NULL,
    [id_document]          INT            NULL,
    [id_owner]             INT            NULL,
    [id_file_status]       INT            NULL,
    [comment]              NVARCHAR (MAX) NULL,
    [create_date]          SMALLDATETIME  NULL,
    [seen_date]            SMALLDATETIME  NULL,
    [download_date]        SMALLDATETIME  NULL,
    [fileSize]             INT            NULL,
    [id_validation_status] INT            NULL,
    CONSTRAINT [PK_rps_fileHisto] PRIMARY KEY CLUSTERED ([id_xhisto] ASC),
    CONSTRAINT [FK_rps_fileHisto_rps_file_validation_status] FOREIGN KEY ([id_validation_status]) REFERENCES [dbo].[rps_file_validation_status] ([id_file_validation_status])
);

