CREATE TABLE [dbo].[k_m_plan_excel_summary] (
    [id_summary]          INT            IDENTITY (1, 1) NOT NULL,
    [id_plan]             INT            NOT NULL,
    [filter_view]         BIT            NOT NULL,
    [filter_title]        NVARCHAR (250) NULL,
    [aggregate_view]      BIT            NOT NULL,
    [aggregate_title]     NVARCHAR (250) NULL,
    [subtotal_row]        BIT            NOT NULL,
    [aggregate_message]   NVARCHAR (MAX) NULL,
    [default_group_level] INT            NULL,
    [bg_color]            NVARCHAR (7)   NULL,
    [border_color]        NVARCHAR (7)   NULL,
    [font_color]          NVARCHAR (7)   NULL,
    [header_bg_color]     NVARCHAR (7)   NULL,
    [header_border_color] NVARCHAR (7)   NULL,
    [header_font_color]   NVARCHAR (7)   NULL,
    CONSTRAINT [PK_k_m_plan_excel_summary] PRIMARY KEY CLUSTERED ([id_summary] ASC)
);

