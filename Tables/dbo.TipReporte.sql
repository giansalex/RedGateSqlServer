CREATE TABLE [dbo].[TipReporte]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_trpt] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[NombreCorto] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipReporte] ADD CONSTRAINT [PK_TipReporte] PRIMARY KEY CLUSTERED  ([RucE], [Cd_trpt]) ON [PRIMARY]
GO
