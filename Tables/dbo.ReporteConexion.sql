CREATE TABLE [dbo].[ReporteConexion]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CadenaConexion] [nvarchar] (300) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NULL,
[NombreConexion] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReporteConexion] ADD CONSTRAINT [PK_ReporteConexion] PRIMARY KEY CLUSTERED  ([RucE]) ON [PRIMARY]
GO
