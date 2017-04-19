CREATE TABLE [dbo].[Reportes]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ReporteID] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NombreReporte] [nvarchar] (60) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DescripcionReporte] [nvarchar] (150) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NombreConsulta] [nvarchar] (150) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reportes] ADD CONSTRAINT [PK_Reportes] PRIMARY KEY CLUSTERED  ([ReporteID], [RucE]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reportes] ADD CONSTRAINT [FK_Reportes_ReporteConexion] FOREIGN KEY ([RucE]) REFERENCES [dbo].[ReporteConexion] ([RucE])
GO
