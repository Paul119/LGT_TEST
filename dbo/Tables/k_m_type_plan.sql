CREATE TABLE [dbo].[k_m_type_plan] (
    [id_type_plan]                               INT            IDENTITY (1, 1) NOT NULL,
    [name_type_plan]                             NVARCHAR (255) NULL,
    [sort]                                       INT            NULL,
    [id_base_grid]                               INT            NULL,
    [id_source_tenant]                           INT            NULL,
    [id_source]                                  INT            NULL,
    [id_change_set]                              INT            NULL,
    [is_estimator_enabled]                       BIT            CONSTRAINT [DF_k_m_type_plan_is_estimator_enabled] DEFAULT ((0)) NOT NULL,
    [post_crediting_stored_procedure]            NVARCHAR (255) NULL,
    [estimator_data_formatter_stored_procedure]  NVARCHAR (255) NULL,
    [estimator_result_producer_stored_procedure] NVARCHAR (255) NULL,
    CONSTRAINT [PK_k_m_type_plan] PRIMARY KEY CLUSTERED ([id_type_plan] ASC),
    CONSTRAINT [FK_k_m_type_plan_k_referential_grids] FOREIGN KEY ([id_base_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid])
);

