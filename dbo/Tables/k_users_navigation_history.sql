CREATE TABLE [dbo].[k_users_navigation_history] (
    [id_users_navigation_history] INT           IDENTITY (1, 1) NOT NULL,
    [id_item]                     INT           NOT NULL,
    [id_module]                   INT           NOT NULL,
    [id_itemtype]                 INT           NULL,
    [id_hierarchy]                INT           NULL,
    [id_accordion_module]         INT           NULL,
    [id_user]                     INT           NULL,
    [id_profile]                  INT           NOT NULL,
    [last_visit_time]             DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_id_users_navigation_history] PRIMARY KEY CLUSTERED ([id_users_navigation_history] ASC),
    CONSTRAINT [FK_k_users_navigation_history_cgTreeItemType] FOREIGN KEY ([id_itemtype]) REFERENCES [dbo].[cgTreeItemType] ([id_itemtype]),
    CONSTRAINT [FK_k_users_navigation_history_k_modules_accordion] FOREIGN KEY ([id_accordion_module]) REFERENCES [dbo].[k_modules] ([id_module]),
    CONSTRAINT [FK_k_users_navigation_history_k_modules_module] FOREIGN KEY ([id_module]) REFERENCES [dbo].[k_modules] ([id_module])
);

