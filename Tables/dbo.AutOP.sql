CREATE TABLE [dbo].[AutOP]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OP] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecAut] [datetime] NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutOP] WITH NOCHECK ADD CONSTRAINT [FK_AutOP_OrdPedido] FOREIGN KEY ([RucE], [Cd_OP]) REFERENCES [dbo].[OrdPedido] ([RucE], [Cd_OP])
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'AutOP', 'COLUMN', N'NomUsu'
GO
