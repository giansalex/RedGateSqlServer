CREATE TABLE [dbo].[Pais]
(
[Cd_Pais] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Siglas] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Pais] ADD CONSTRAINT [PK_Pais] PRIMARY KEY CLUSTERED  ([Cd_Pais]) ON [PRIMARY]
GO
