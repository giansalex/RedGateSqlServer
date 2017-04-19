CREATE TABLE [dbo].[ListaPrecio_Autorizados]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_LP] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL,
[FechaAsignacion] [date] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecio_Autorizados] ADD CONSTRAINT [PK_ListaPrecio_Autorizados] PRIMARY KEY CLUSTERED  ([RucE], [Cd_LP], [NomUsu]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecio_Autorizados] ADD CONSTRAINT [FK_ListaPrecio_Autorizados_ListaPrecio] FOREIGN KEY ([RucE], [Cd_LP]) REFERENCES [dbo].[ListaPrecio] ([RucE], [Cd_LP])
GO
ALTER TABLE [dbo].[ListaPrecio_Autorizados] ADD CONSTRAINT [FK_ListaPrecio_Autorizados_Usuario] FOREIGN KEY ([NomUsu]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
