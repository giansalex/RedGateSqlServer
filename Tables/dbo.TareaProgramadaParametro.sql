CREATE TABLE [dbo].[TareaProgramadaParametro]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[TareaProgramadaID] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ReporteID] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ReporteParametroID] [int] NOT NULL,
[ValorParametro] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TareaProgramadaParametro] ADD CONSTRAINT [PK_TareaProgramadaParametro] PRIMARY KEY CLUSTERED  ([RucE], [TareaProgramadaID], [ReporteID], [ReporteParametroID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TareaProgramadaParametro] ADD CONSTRAINT [FK_TareaProgramadaParametro_ReporteParametros] FOREIGN KEY ([RucE], [ReporteID], [ReporteParametroID]) REFERENCES [dbo].[ReporteParametros] ([RucE], [ReporteID], [ReporteParametroID])
GO
ALTER TABLE [dbo].[TareaProgramadaParametro] ADD CONSTRAINT [FK_TareaProgramadaParametro_TareaProgramada] FOREIGN KEY ([RucE], [TareaProgramadaID]) REFERENCES [dbo].[TareaProgramada] ([RucE], [TareaProgramadaID])
GO
