CREATE TABLE [dbo].[hm_NodeTree] (
    [id]                  INT            IDENTITY (1, 1) NOT NULL,
    [name]                NVARCHAR (100) NULL,
    [idOwner]             INT            NULL,
    [createDate]          DATETIME       NULL,
    [allowRepeatingItems] BIT            NULL,
    [id_source_tenant]    INT            NULL,
    [id_source]           INT            NULL,
    [id_change_set]       INT            NULL,
    [type]                INT            NULL,
    [payee_name_template] NVARCHAR (100) CONSTRAINT [DF_hm_NodeTree_payee_name_template] DEFAULT ('{firstname} {lastname}') NOT NULL,
    CONSTRAINT [PK_hm_NodeTree] PRIMARY KEY CLUSTERED ([id] ASC)
);

