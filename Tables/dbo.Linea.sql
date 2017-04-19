CREATE TABLE [dbo].[Linea]
(
[Cd_Ln] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linea] ADD CONSTRAINT [PK_Linea] PRIMARY KEY CLUSTERED  ([Cd_Ln]) ON [PRIMARY]
GO
