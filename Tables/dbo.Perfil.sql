CREATE TABLE [dbo].[Perfil]
(
[Cd_Prf] [nvarchar] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomP] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[NivUsuCrea] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Perfil] ADD CONSTRAINT [PK_Perfil] PRIMARY KEY CLUSTERED  ([Cd_Prf]) ON [PRIMARY]
GO
