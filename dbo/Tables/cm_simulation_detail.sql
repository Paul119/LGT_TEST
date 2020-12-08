CREATE TABLE [dbo].[cm_simulation_detail] (
    [id_simulationdetail] INT           IDENTITY (1, 1) NOT NULL,
    [id_simulation]       INT           NULL,
    [id_original]         INT           NULL,
    [id_copied]           INT           NULL,
    [type]                NVARCHAR (50) NULL,
    [id_type]             INT           NULL,
    [action_type]         NVARCHAR (50) NULL,
    CONSTRAINT [PK_cm_simulation_detail] PRIMARY KEY CLUSTERED ([id_simulationdetail] ASC),
    CONSTRAINT [FK_cm_simulation_detail_cm_simulation] FOREIGN KEY ([id_simulation]) REFERENCES [dbo].[cm_simulation] ([simulation_id])
);

