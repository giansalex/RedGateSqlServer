CREATE TABLE [dbo].[GrupoPermisos]
(
[Cd_GP] [int] NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NivUsuCrea] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GrupoPermisos] ADD CONSTRAINT [PK_GrupoPermisos] PRIMARY KEY CLUSTERED  ([Cd_GP]) ON [PRIMARY]
GO
