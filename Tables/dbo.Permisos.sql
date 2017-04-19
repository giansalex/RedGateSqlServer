CREATE TABLE [dbo].[Permisos]
(
[Cd_Pm] [varchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Permisos] ADD CONSTRAINT [PK_Permisos] PRIMARY KEY CLUSTERED  ([Cd_Pm]) ON [PRIMARY]
GO
