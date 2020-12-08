CREATE TABLE [dbo].[k_rights] (
    [id_right]       INT            IDENTITY (1, 1) NOT NULL,
    [name_right]     NVARCHAR (50)  NOT NULL,
    [comments_right] NVARCHAR (MAX) NULL,
    CONSTRAINT [pk_k_rights] PRIMARY KEY CLUSTERED ([id_right] ASC)
);

