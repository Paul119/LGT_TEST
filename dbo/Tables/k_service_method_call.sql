CREATE TABLE [dbo].[k_service_method_call] (
    [call_id]           INT            IDENTITY (1, 1) NOT NULL,
    [user_id]           INT            NOT NULL,
    [create_date]       DATETIME       NOT NULL,
    [modify_date]       DATETIME       NULL,
    [call_response]     NVARCHAR (MAX) NULL,
    [is_call_finished]  BIT            NOT NULL,
    [service_id]        INT            NOT NULL,
    [service_method_id] INT            NOT NULL,
    [item_id]           INT            NULL,
    [expiry_date]       DATETIME       NULL,
    [method]            NVARCHAR (100) NULL,
    [callHash]          NVARCHAR (255) NULL,
    [callUId]           NVARCHAR (255) NULL,
    CONSTRAINT [PK_k_service_method_call] PRIMARY KEY CLUSTERED ([call_id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_k_service_method_call_item_id]
    ON [dbo].[k_service_method_call]([service_id] ASC, [service_method_id] ASC, [method] ASC, [item_id] ASC, [user_id] ASC) WHERE ([is_call_finished]=(0));

