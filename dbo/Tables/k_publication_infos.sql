CREATE TABLE [dbo].[k_publication_infos] (
    [id_publication_infos] INT            IDENTITY (1, 1) NOT NULL,
    [id_table_payment]     INT            NOT NULL,
    [id_table_publication] INT            NULL,
    [min_date_data]        SMALLDATETIME  NULL,
    [max_date_data]        SMALLDATETIME  NULL,
    [date_publication]     SMALLDATETIME  NULL,
    [lastname_user]        NVARCHAR (100) NULL,
    [comm1_publication]    NVARCHAR (MAX) NULL,
    [version]              NVARCHAR (50)  NULL,
    [nb_lines]             INT            NULL,
    [id_prog]              INT            NULL,
    [id_cond]              INT            NULL,
    CONSTRAINT [PK_k_publication_infos] PRIMARY KEY CLUSTERED ([id_publication_infos] ASC)
);

