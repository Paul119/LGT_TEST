CREATE TYPE [dbo].[Kernel_Type_Update_Values] AS TABLE (
    [step_id] INT            NOT NULL,
    [pif]     NVARCHAR (20)  NOT NULL,
    [value]   NVARCHAR (MAX) NULL,
    [idSim]   INT            NULL);

