CREATE TABLE [dbo].[GrupoAcceso]
(
[Cd_GA] [int] NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[NivUsuCrea] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GrupoAcceso] ADD CONSTRAINT [PK_GrupoAcceso] PRIMARY KEY CLUSTERED  ([Cd_GA]) ON [PRIMARY]
GO
