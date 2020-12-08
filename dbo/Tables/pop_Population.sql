CREATE TABLE [dbo].[pop_Population] (
    [idPop]            INT            IDENTITY (1, 1) NOT NULL,
    [idparent]         INT            NULL,
    [name]             NVARCHAR (50)  NOT NULL,
    [lastVersion]      INT            NULL,
    [isFixed]          BIT            NULL,
    [htmlCond]         NVARCHAR (MAX) NULL,
    [sqlCond]          NVARCHAR (MAX) NULL,
    [idUniverse]       INT            NOT NULL,
    [idOwner]          INT            NULL,
    [createDate]       DATETIME       NULL,
    [isSimulated]      BIT            CONSTRAINT [DF_pop_Population_isSimulated] DEFAULT ((0)) NULL,
    [id_source_tenant] INT            NULL,
    [id_source]        INT            NULL,
    [id_change_set]    INT            NULL,
    CONSTRAINT [PK_pop_Population] PRIMARY KEY CLUSTERED ([idPop] ASC),
    CONSTRAINT [FK_pop_Population_k_program_cond_universes] FOREIGN KEY ([idUniverse]) REFERENCES [dbo].[k_program_cond_universes] ([id_universe]),
    CONSTRAINT [FK_pop_Population_pop_PopulationFolder] FOREIGN KEY ([idparent]) REFERENCES [dbo].[pop_Folders] ([idFolder]),
    CONSTRAINT [FK_pop_Population_pop_PopulationVersion] FOREIGN KEY ([lastVersion]) REFERENCES [dbo].[pop_PopulationVersion] ([id])
);

