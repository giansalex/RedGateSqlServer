CREATE TABLE [dbo].[UnidadMedida]
(
[Cd_UM] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CodSNT_] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UnidadMedida] ADD CONSTRAINT [PK_UnidadMedida] PRIMARY KEY CLUSTERED  ([Cd_UM]) ON [PRIMARY]
GO
