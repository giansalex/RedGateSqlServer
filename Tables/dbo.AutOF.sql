CREATE TABLE [dbo].[AutOF]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OF] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecAut] [datetime] NOT NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutOF] ADD CONSTRAINT [FK_AutOF_OrdFabricacion] FOREIGN KEY ([RucE], [Cd_OF]) REFERENCES [dbo].[OrdFabricacion] ([RucE], [Cd_OF])
GO
EXEC sp_addextendedproperty N'MS_Description', N'OF00000001', 'SCHEMA', N'dbo', 'TABLE', N'AutOF', 'COLUMN', N'Cd_OF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'AutOF', 'COLUMN', N'NomUsu'
GO
