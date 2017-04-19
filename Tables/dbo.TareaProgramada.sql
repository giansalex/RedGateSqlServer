CREATE TABLE [dbo].[TareaProgramada]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[TareaProgramadaID] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Correo] [nvarchar] (160) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FechaInicio] [date] NULL,
[FechaFin] [date] NULL,
[SoloLunes] [bit] NOT NULL,
[SoloMartes] [bit] NOT NULL,
[SoloMiercoles] [bit] NOT NULL,
[SoloJueves] [bit] NOT NULL,
[SoloViernes] [bit] NOT NULL,
[SoloSabados] [bit] NOT NULL,
[SoloDomingos] [bit] NOT NULL,
[EsRecurrente] [bit] NOT NULL,
[Hora1] [time] NOT NULL,
[Hora2] [time] NULL,
[Hora3] [time] NULL,
[Estado] [int] NOT NULL,
[Asunto] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[AltaPrioridad] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TareaProgramada] ADD CONSTRAINT [PK_TareaProgramada] PRIMARY KEY CLUSTERED  ([RucE], [TareaProgramadaID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TareaProgramada] ADD CONSTRAINT [FK_TareaProgramada_ReporteConexion] FOREIGN KEY ([RucE]) REFERENCES [dbo].[ReporteConexion] ([RucE])
GO
EXEC sp_addextendedproperty N'MS_Description', N'1: Activo, 2: Pausado, 3:Eliminado', 'SCHEMA', N'dbo', 'TABLE', N'TareaProgramada', 'COLUMN', N'Estado'
GO
