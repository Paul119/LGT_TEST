CREATE TABLE [dbo].[hm_node_link_xhisto] (
    [id_xhisto]              INT            IDENTITY (1, 1) NOT NULL,
    [id_user_xhisto]         INT            NULL,
    [dt_xhisto]              DATETIME       NULL,
    [type_xhisto]            CHAR (3)       NULL,
    [o_id_tree]              INT            NULL,
    [o_id_child]             INT            NULL,
    [o_id_type]              INT            NULL,
    [o_id_parent_old]        INT            NULL,
    [o_id_type_parent_old]   INT            NULL,
    [o_id_real_parent_old]   INT            NULL,
    [o_id_unique_parent_old] INT            NULL,
    [o_id_parent_new]        INT            NULL,
    [o_id_type_parent_new]   INT            NULL,
    [o_id_real_parent_new]   INT            NULL,
    [o_id_unique_parent_new] INT            NULL,
    [description]            NVARCHAR (100) NULL,
    CONSTRAINT [PK_hm_node_link_xhisto] PRIMARY KEY CLUSTERED ([id_xhisto] ASC)
);

