CREATE TABLE [dbo].[k_m_period] (
    [id_period]          INT            IDENTITY (1, 1) NOT NULL,
    [name_period]        NVARCHAR (255) NOT NULL,
    [start_date]         DATETIME       NOT NULL,
    [status_period]      INT            NULL,
    [length_period]      TINYINT        CONSTRAINT [DF_k_m_period_length_period] DEFAULT ((12)) NULL,
    [sort]               INT            NULL,
    [id_user_create]     INT            NULL,
    [date_create_period] DATETIME       NULL,
    [id_user_update]     INT            NULL,
    [date_update_period] DATETIME       NULL,
    [end_date]           DATETIME       NOT NULL,
    [id_source_tenant]   INT            NULL,
    [id_source]          INT            NULL,
    [id_change_set]      INT            NULL,
    CONSTRAINT [PK_k_m_periode] PRIMARY KEY CLUSTERED ([id_period] ASC)
);

