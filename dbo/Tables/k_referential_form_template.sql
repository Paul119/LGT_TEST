CREATE TABLE [dbo].[k_referential_form_template] (
    [form_template_id]      INT            IDENTITY (1, 1) NOT NULL,
    [form_template_name]    NVARCHAR (255) NOT NULL,
    [form_template_content] NVARCHAR (MAX) NOT NULL,
    [comments]              NVARCHAR (255) NULL,
    CONSTRAINT [PK_k_referential_form_template] PRIMARY KEY CLUSTERED ([form_template_id] ASC)
);

