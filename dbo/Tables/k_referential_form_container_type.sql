CREATE TABLE [dbo].[k_referential_form_container_type] (
    [container_type_id]   INT           IDENTITY (1, 1) NOT NULL,
    [container_type_name] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_k_referential_form_container_type] PRIMARY KEY CLUSTERED ([container_type_id] ASC)
);

