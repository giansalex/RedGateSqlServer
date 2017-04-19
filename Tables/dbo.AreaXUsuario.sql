CREATE TABLE [dbo].[AreaXUsuario]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AreaXUsuario] ADD CONSTRAINT [PK_AreaXUsuario] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Area], [NomUsu]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AreaXUsuario] ADD CONSTRAINT [FK_AreaXUsuario_Area] FOREIGN KEY ([RucE], [Cd_Area]) REFERENCES [dbo].[Area] ([RucE], [Cd_Area])
GO
ALTER TABLE [dbo].[AreaXUsuario] ADD CONSTRAINT [FK_AreaXUsuario_Usuario] FOREIGN KEY ([NomUsu]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
