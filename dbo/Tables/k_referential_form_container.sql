CREATE TABLE [dbo].[k_referential_form_container] (
    [container_id]        INT             IDENTITY (1, 1) NOT NULL,
    [title]               NVARCHAR (1000) NULL,
    [border]              BIT             NOT NULL,
    [flex]                INT             NOT NULL,
    [type]                INT             NOT NULL,
    [control_per_line]    INT             NOT NULL,
    [parent_container_id] INT             NULL,
    [root_container_id]   INT             NULL,
    [group_id]            INT             NULL,
    [id_source_tenant]    INT             NULL,
    [id_source]           INT             NULL,
    [id_change_set]       INT             NULL,
    [sort_order]          INT             NULL,
    [group_name]          NVARCHAR (250)  NULL,
    [description]         NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_k_referential_form_container] PRIMARY KEY CLUSTERED ([container_id] ASC),
    CONSTRAINT [FK_k_referential_form_container_k_referential_form_container_type] FOREIGN KEY ([type]) REFERENCES [dbo].[k_referential_form_container_type] ([container_type_id])
);

