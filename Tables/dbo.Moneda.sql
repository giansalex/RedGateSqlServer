CREATE TABLE [dbo].[Moneda]
(
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Simbolo] [varchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Moneda] ADD CONSTRAINT [PK_Moneda] PRIMARY KEY CLUSTERED  ([Cd_Mda]) ON [PRIMARY]
GO
