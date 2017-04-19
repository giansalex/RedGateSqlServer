CREATE TABLE [dbo].[TipGasto]
(
[Cd_TG] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipGasto] ADD CONSTRAINT [PK_TipGasto] PRIMARY KEY CLUSTERED  ([Cd_TG]) ON [PRIMARY]
GO
