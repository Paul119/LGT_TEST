﻿CREATE TABLE [dbo].[k_program] (
    [id_prog]             INT             IDENTITY (1, 1) NOT NULL,
    [id_parent]           INT             NULL,
    [name_prog]           NVARCHAR (50)   NOT NULL,
    [budget_prog]         DECIMAL (18, 2) NULL,
    [amount_prog]         DECIMAL (18, 2) NULL,
    [unit_prog]           INT             NULL,
    [id_status]           SMALLINT        NULL,
    [id_type]             INT             NULL,
    [id_category]         INT             NULL,
    [id_frequency]        INT             NULL,
    [color_trans]         NVARCHAR (24)   NULL,
    [date_begin_prog]     SMALLDATETIME   NULL,
    [date_end_prog]       SMALLDATETIME   NULL,
    [date_last_calc_prog] DATETIME        NULL,
    [active_prog]         CHAR (1)        NULL,
    [version_data]        INT             CONSTRAINT [DF_k_program_version_data] DEFAULT ((-2)) NOT NULL,
    [comments_prog]       NVARCHAR (MAX)  NULL,
    [id_owner]            INT             NULL,
    [date_created]        SMALLDATETIME   NULL,
    [date_last_modified]  SMALLDATETIME   NULL,
    [is_simulated]        BIT             NULL,
    [id_source_tenant]    INT             NULL,
    [id_source]           INT             NULL,
    [id_change_set]       INT             NULL,
    CONSTRAINT [PK_k_program] PRIMARY KEY CLUSTERED ([id_prog] ASC),
    CONSTRAINT [FK_k_program_k_program_category] FOREIGN KEY ([id_category]) REFERENCES [dbo].[k_program_category] ([id_category]),
    CONSTRAINT [FK_k_program_k_program_folders] FOREIGN KEY ([id_parent]) REFERENCES [dbo].[k_program_folders] ([id_folder]) ON DELETE CASCADE,
    CONSTRAINT [FK_k_program_k_program_frequency] FOREIGN KEY ([id_frequency]) REFERENCES [dbo].[k_program_frequency] ([id_frequency]),
    CONSTRAINT [FK_k_program_k_program_type] FOREIGN KEY ([id_type]) REFERENCES [dbo].[k_program_type] ([id_type]),
    CONSTRAINT [FK_k_program_k_unit] FOREIGN KEY ([unit_prog]) REFERENCES [dbo].[k_unit] ([unit_id]),
    CONSTRAINT [FK_k_program_k_versions] FOREIGN KEY ([version_data]) REFERENCES [dbo].[k_versions] ([id_version])
);

