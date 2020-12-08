CREATE TABLE [dbo].[grid_data_temp_values] (
    [Unique_Key]   VARCHAR (50)   NOT NULL,
    [PK_Id]        NVARCHAR (MAX) NULL,
    [Column_Name]  NVARCHAR (MAX) NULL,
    [Column_Value] NVARCHAR (MAX) NULL,
    [Field_Id]     INT            NULL,
    [Process_Type] VARCHAR (3)    NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex_UniqueKey]
    ON [dbo].[grid_data_temp_values]([Unique_Key] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex_UniqueKey_ProcessType]
    ON [dbo].[grid_data_temp_values]([Unique_Key] ASC, [Process_Type] ASC);

