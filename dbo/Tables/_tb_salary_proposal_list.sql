CREATE TABLE [dbo].[_tb_salary_proposal_list] (
    [salaryproposalId] INT          IDENTITY (1, 1) NOT NULL,
    [Currency]         NVARCHAR (3) NOT NULL,
    [Amount]           INT          NOT NULL,
    CONSTRAINT [pk_tb_salary_proposal_list_salaryproposalId] PRIMARY KEY CLUSTERED ([salaryproposalId] ASC)
);

