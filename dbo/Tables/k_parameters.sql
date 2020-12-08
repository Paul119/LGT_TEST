CREATE TABLE [dbo].[k_parameters] (
    [id_parameter]      INT            NOT NULL,
    [key_parameter]     NVARCHAR (50)  NULL,
    [value_parameter]   NVARCHAR (500) NULL,
    [group_parameter]   NVARCHAR (50)  NULL,
    [visible_parameter] BIT            NULL,
    [id_control]        INT            NULL,
    [sort]              INT            NULL,
    [date_modification] SMALLDATETIME  NULL,
    CONSTRAINT [PK_k_parameters] PRIMARY KEY CLUSTERED ([id_parameter] ASC)
);

