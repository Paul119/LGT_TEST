CREATE TABLE [dbo].[k_m_plan_profile_status_xhisto] (
    [id_xhisto]                    INT            IDENTITY (1, 1) NOT NULL,
    [id_user_xhisto]               INT            NOT NULL,
    [dt_xhisto]                    DATETIME       NOT NULL,
    [type_xhisto]                  CHAR (3)       NOT NULL,
    [id_plan_profile_status]       INT            NOT NULL,
    [id_plan_profile_status_group] INT            NOT NULL,
    [id_plan_status]               INT            NOT NULL,
    [start_date]                   DATETIME       NOT NULL,
    [description]                  NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_m_plan_profile_status_xhisto] PRIMARY KEY CLUSTERED ([id_xhisto] ASC)
);

