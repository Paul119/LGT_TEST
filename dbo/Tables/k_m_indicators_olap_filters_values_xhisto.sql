CREATE TABLE [dbo].[k_m_indicators_olap_filters_values_xhisto] (
    [id_xhisto]               INT            IDENTITY (1, 1) NOT NULL,
    [id_user_xhisto]          INT            NULL,
    [dt_xhisto]               DATETIME       NULL,
    [type_xhisto]             CHAR (3)       NULL,
    [o_id_ind]                INT            NULL,
    [o_id_reference]          INT            NULL,
    [o_id_object_reference]   NVARCHAR (255) NULL,
    [o_name_object_reference] NVARCHAR (255) NULL,
    CONSTRAINT [PK__k_m_indi__679B63AF53B6DBB8] PRIMARY KEY CLUSTERED ([id_xhisto] ASC)
);

