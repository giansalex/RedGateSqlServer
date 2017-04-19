CREATE TABLE [dbo].[TipoExistencia]
(
[Cd_TE] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CodSNT_] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Nombre] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipoExistencia] ADD CONSTRAINT [PK_TipoExistencia] PRIMARY KEY CLUSTERED  ([Cd_TE]) ON [PRIMARY]
GO
