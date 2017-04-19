CREATE TABLE [dbo].[ControlGrupos]
(
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[JefeUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nivel] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[FecIni] [datetime] NOT NULL,
[FecFin] [datetime] NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ControlGrupos] WITH NOCHECK ADD CONSTRAINT [FK_ControlGrupos_Usuario] FOREIGN KEY ([NomUsu]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
ALTER TABLE [dbo].[ControlGrupos] WITH NOCHECK ADD CONSTRAINT [FK_ControlGrupos_Usuario1] FOREIGN KEY ([JefeUsu]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
