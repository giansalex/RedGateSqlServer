CREATE TABLE [dbo].[CfgAutsXUsuario]
(
[Id_Niv] [int] NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgAutsXUsuario] WITH NOCHECK ADD CONSTRAINT [FK_AutsXUsuario_Usuario] FOREIGN KEY ([NomUsu]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
ALTER TABLE [dbo].[CfgAutsXUsuario] WITH NOCHECK ADD CONSTRAINT [FK_CfgAutsXUsuario_CfgNivelAut] FOREIGN KEY ([Id_Niv]) REFERENCES [dbo].[CfgNivelAut] ([Id_Niv]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'CfgAutsXUsuario', 'COLUMN', N'NomUsu'
GO
