CREATE TABLE [dbo].[TipoOperacion]
(
[Cd_TO] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CodSNT_] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Nombre] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipoOperacion] ADD CONSTRAINT [PK_TipoOperacion] PRIMARY KEY CLUSTERED  ([Cd_TO]) ON [PRIMARY]
GO
