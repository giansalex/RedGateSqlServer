CREATE TABLE [dbo].[RubrosRpt]
(
[Cd_Rb] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IN_Nivel] [smallint] NOT NULL,
[Simbolo] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Formula] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RubrosRpt] ADD CONSTRAINT [PK_ReporteEF] PRIMARY KEY CLUSTERED  ([Cd_Rb]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RubrosRpt] WITH NOCHECK ADD CONSTRAINT [FK_RubrosEF_TipoReporte] FOREIGN KEY ([Cd_TR]) REFERENCES [dbo].[TipoReporte] ([Cd_TR])
GO
