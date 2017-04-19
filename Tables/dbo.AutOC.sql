CREATE TABLE [dbo].[AutOC]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OC] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecAut] [datetime] NOT NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutOC] WITH NOCHECK ADD CONSTRAINT [FK_AutOC_OrdCompra] FOREIGN KEY ([RucE], [Cd_OC]) REFERENCES [dbo].[OrdCompra] ([RucE], [Cd_OC]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'OC00000001', 'SCHEMA', N'dbo', 'TABLE', N'AutOC', 'COLUMN', N'Cd_OC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'AutOC', 'COLUMN', N'NomUsu'
GO
