CREATE TABLE [dbo].[Categoria]
(
[Cd_Cat] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categoria] ADD CONSTRAINT [PK_Categoria] PRIMARY KEY CLUSTERED  ([Cd_Cat]) ON [PRIMARY]
GO
