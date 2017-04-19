CREATE TABLE [dbo].[ColumnasReporte]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ReporteID] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ColumnaReporteID] [int] NOT NULL,
[NombreColumna] [nvarchar] (45) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ColorColumna] [nvarchar] (9) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ColorLetraColumna] [nvarchar] (9) COLLATE Modern_Spanish_CI_AS NOT NULL,
[EnNegrita] [bit] NOT NULL,
[Derecha] [bit] NOT NULL,
[TextoColumna] [nvarchar] (70) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ColumnasReporte] ADD CONSTRAINT [PK_ColumnasReporte] PRIMARY KEY CLUSTERED  ([RucE], [ReporteID], [ColumnaReporteID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ColumnasReporte] ADD CONSTRAINT [FK_ColumnasReporte_Reportes] FOREIGN KEY ([ReporteID], [RucE]) REFERENCES [dbo].[Reportes] ([ReporteID], [RucE])
GO
