CREATE TABLE [dbo].[k_referential_routine] (
    [id_routine]             INT            IDENTITY (1, 1) NOT NULL,
    [name_routine]           NVARCHAR (250) NOT NULL,
    [type_routine]           TINYINT        NOT NULL,
    [is_return_type_numeric] BIT            CONSTRAINT [DF_k_referential_routine_is_return_type_numeric] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_k_referential_routine] PRIMARY KEY CLUSTERED ([id_routine] ASC),
    CONSTRAINT [FK_k_referential_routine_type_routine] FOREIGN KEY ([type_routine]) REFERENCES [dbo].[k_referential_routine_type] ([id_routine_type])
);

