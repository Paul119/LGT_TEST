﻿CREATE TABLE [dbo].[k_m_plans] (
    [id_plan]                                   INT              IDENTITY (1, 1) NOT NULL,
    [name_plan]                                 NVARCHAR (255)   NOT NULL,
    [comment_plan]                              NVARCHAR (MAX)   NULL,
    [nb_frozen_columns]                         INT              NULL,
    [id_parent]                                 INT              NULL,
    [nb_default_page_size]                      INT              NULL,
    [nb_indicator_plan]                         INT              NULL,
    [status_plan]                               INT              NULL,
    [id_type_plan]                              INT              NULL,
    [id_frequency]                              INT              NULL,
    [id_period]                                 INT              NULL,
    [id_workflow]                               INT              CONSTRAINT [DF_k_m_plans_id_workflow] DEFAULT (NULL) NULL,
    [id_form]                                   INT              NULL,
    [id_report]                                 INT              NULL,
    [id_owner]                                  INT              NULL,
    [date_create_plan]                          DATETIME         NULL,
    [id_user_update]                            INT              NULL,
    [date_update_plan]                          DATETIME         NULL,
    [selfAppraisal]                             BIT              NULL,
    [idLevelComment]                            INT              CONSTRAINT [DF_k_m_plans_idLevelComment] DEFAULT ((1)) NULL,
    [start_date_plan]                           DATETIME         NOT NULL,
    [end_date_plan]                             DATETIME         NOT NULL,
    [is_begin_date_frequency_start]             BIT              NULL,
    [id_plan_layout_type]                       INT              CONSTRAINT [DF_k_m_plans_id_plan_layout_type] DEFAULT ((-1)) NOT NULL,
    [root_form_container_id]                    INT              NULL,
    [id_source_tenant]                          INT              NULL,
    [id_source]                                 INT              NULL,
    [id_change_set]                             INT              NULL,
    [is_workflow_active]                        BIT              NULL,
    [show_employee_info_template]               BIT              CONSTRAINT [DF_k_m_plans_show_employee_info_template] DEFAULT ((1)) NULL,
    [is_quota_enabled]                          BIT              CONSTRAINT [DF_k_m_plans_is_quota_enabled] DEFAULT ((0)) NOT NULL,
    [id_structure]                              INT              CONSTRAINT [DF_k_m_plans_id_structure] DEFAULT (NULL) NULL,
    [tqm_showExtraColumns]                      BIT              CONSTRAINT [DF_k_m_plans_tqm_showExtraColumns] DEFAULT ((0)) NOT NULL,
    [id_plan_importexport_options]              INT              NULL,
    [page_size]                                 INT              CONSTRAINT [DF_k_m_plans_page_size] DEFAULT ((10)) NOT NULL,
    [is_level_calculation_payee_only]           BIT              NULL,
    [filter_start_date_visibility]              BIT              CONSTRAINT [DF_k_m_plans_filter_start_date_visibility] DEFAULT ((1)) NOT NULL,
    [filter_end_date_visibility]                BIT              CONSTRAINT [DF_k_m_plans_filter_end_date_visibility] DEFAULT ((1)) NOT NULL,
    [filter_workflow_step_visibility]           BIT              CONSTRAINT [DF_k_m_plans_filter_workflow_step_visibility] DEFAULT ((1)) NOT NULL,
    [sort_order_start_date]                     INT              CONSTRAINT [DF_k_m_plans_sort_order_start_date] DEFAULT ((0)) NOT NULL,
    [sort_order_end_date]                       INT              CONSTRAINT [DF_k_m_plans_sort_order_end_date] DEFAULT ((0)) NOT NULL,
    [sort_order_workflow_step]                  INT              CONSTRAINT [DF_k_m_plans_sort_order_workflow_step] DEFAULT ((0)) NOT NULL,
    [sort_order_workflow_status]                INT              CONSTRAINT [DF_k_m_plans_sort_order_workflow_status] DEFAULT ((0)) NOT NULL,
    [available_start_date]                      BIT              CONSTRAINT [DF_k_m_plans_available_start_date] DEFAULT ((1)) NOT NULL,
    [available_end_date]                        BIT              CONSTRAINT [DF_k_m_plans_available_end_date] DEFAULT ((1)) NOT NULL,
    [available_workflow_status]                 BIT              CONSTRAINT [DF_k_m_plans_available_workflow_status] DEFAULT ((1)) NOT NULL,
    [available_workflow_step_name]              BIT              CONSTRAINT [DF_k_m_plans_available_workflow_step_name] DEFAULT ((1)) NOT NULL,
    [start_date_is_locked]                      BIT              CONSTRAINT [DF_k_m_plans_start_date_is_locked] DEFAULT ((0)) NOT NULL,
    [end_date_is_locked]                        BIT              CONSTRAINT [DF_k_m_plans_end_date_is_locked] DEFAULT ((0)) NOT NULL,
    [workflow_status_is_locked]                 BIT              CONSTRAINT [DF_k_m_plans_workflow_status_is_locked] DEFAULT ((0)) NOT NULL,
    [workflow_step_is_locked]                   BIT              CONSTRAINT [DF_k_m_plans_workflow_step_is_locked] DEFAULT ((0)) NOT NULL,
    [default_level]                             NVARCHAR (10)    CONSTRAINT [DF_k_m_plans_default_level] DEFAULT ((1)) NOT NULL,
    [is_data_grouping_allowed]                  BIT              CONSTRAINT [DF_k_m_plans_is_data_grouping_allowed] DEFAULT ((1)) NOT NULL,
    [is_simulatable]                            BIT              CONSTRAINT [DF_k_m_plans_is_simulatable] DEFAULT ((1)) NOT NULL,
    [attached_object_close_after_save]          BIT              CONSTRAINT [DF_k_m_plans_attached_object_close_after_save] DEFAULT ((1)) NOT NULL,
    [attached_object_refresh_after_save]        BIT              CONSTRAINT [DF_k_m_plans_attached_object_refresh_after_save] DEFAULT ((1)) NOT NULL,
    [attached_object_refresh_after_save_always] BIT              CONSTRAINT [DF_k_m_plans_attached_object_refresh_after_save_always] DEFAULT ((0)) NOT NULL,
    [attached_object_height]                    INT              CONSTRAINT [DF_k_m_plans_attached_object_height] DEFAULT ((33)) NOT NULL,
    [wrap_header]                               BIT              DEFAULT ((0)) NOT NULL,
    [header_tooltip]                            BIT              DEFAULT ((0)) NOT NULL,
    [width_start_date]                          INT              DEFAULT ((100)) NOT NULL,
    [width_end_date]                            INT              DEFAULT ((100)) NOT NULL,
    [width_workflow_status]                     INT              DEFAULT ((100)) NOT NULL,
    [width_workflow_step_name]                  INT              DEFAULT ((100)) NOT NULL,
    [is_picture_shown]                          BIT              CONSTRAINT [DF_k_m_plans_is_picture_shown] DEFAULT ((0)) NOT NULL,
    [enable_group_summary]                      BIT              NULL,
    [allow_attached_file]                       BIT              CONSTRAINT [DF_k_m_plans_allow_attached_file] DEFAULT ((0)) NOT NULL,
    [uid_object]                                UNIQUEIDENTIFIER NULL,
    [uid_datasource]                            UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_k_m_plans] PRIMARY KEY CLUSTERED ([id_plan] ASC),
    CONSTRAINT [FK_k_m_plans_k_m_frequency] FOREIGN KEY ([id_frequency]) REFERENCES [dbo].[k_m_frequency] ([id_frequency]),
    CONSTRAINT [FK_k_m_plans_k_m_period] FOREIGN KEY ([id_period]) REFERENCES [dbo].[k_m_period] ([id_period]),
    CONSTRAINT [FK_k_m_plans_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_k_m_plans_k_m_type_plan] FOREIGN KEY ([id_type_plan]) REFERENCES [dbo].[k_m_type_plan] ([id_type_plan]),
    CONSTRAINT [FK_k_m_plans_k_m_workflow] FOREIGN KEY ([id_workflow]) REFERENCES [dbo].[k_m_workflow] ([id_workflow]),
    CONSTRAINT [FK_k_m_plans_k_referential_form_container] FOREIGN KEY ([root_form_container_id]) REFERENCES [dbo].[k_referential_form_container] ([container_id]),
    CONSTRAINT [FK_k_m_plans_k_tqm_structure] FOREIGN KEY ([id_structure]) REFERENCES [dbo].[k_tqm_structure] ([id_structure])
);
