CREATE TABLE [dbo].[TipoReporte]
(
[Cd_TR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipoReporte] ADD CONSTRAINT [PK_TipoReporte] PRIMARY KEY CLUSTERED  ([Cd_TR]) ON [PRIMARY]
GO
