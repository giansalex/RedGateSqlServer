CREATE TABLE [dbo].[ReporteParametros]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ReporteID] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ReporteParametroID] [int] NOT NULL,
[NombreParametro] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[TipoParametro] [varchar] (30) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DescripcionParametro] [varchar] (150) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReporteParametros] ADD CONSTRAINT [PK_ReporteParametros] PRIMARY KEY CLUSTERED  ([RucE], [ReporteID], [ReporteParametroID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReporteParametros] ADD CONSTRAINT [FK_ReporteParametros_Reportes] FOREIGN KEY ([ReporteID], [RucE]) REFERENCES [dbo].[Reportes] ([ReporteID], [RucE])
GO
