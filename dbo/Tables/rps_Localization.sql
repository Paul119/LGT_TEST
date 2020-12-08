CREATE TABLE [dbo].[rps_Localization] (
    [localization_id]     INT            IDENTITY (1, 1) NOT NULL,
    [tab_id]              INT            NULL,
    [module_type]         INT            NOT NULL,
    [item_id]             INT            NULL,
    [name]                NVARCHAR (250) NOT NULL,
    [value]               NVARCHAR (MAX) NOT NULL,
    [culture]             NVARCHAR (10)  NOT NULL,
    [type_source]         INT            NULL,
    [ref_localization_id] INT            NULL,
    CONSTRAINT [PK_rps_Localization] PRIMARY KEY CLUSTERED ([localization_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_rps_localization_name]
    ON [dbo].[rps_Localization]([name] ASC)
    INCLUDE([value]);

