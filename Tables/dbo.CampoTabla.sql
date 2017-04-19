CREATE TABLE [dbo].[CampoTabla]
(
[Id_CTb] [int] NOT NULL,
[Cd_Tab] [char] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomCol] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomDef] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CampoTabla] ADD CONSTRAINT [PK_CampoTabla] PRIMARY KEY CLUSTERED  ([Id_CTb]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CampoTabla] WITH NOCHECK ADD CONSTRAINT [FK_CampoTabla_Tabla] FOREIGN KEY ([Cd_Tab]) REFERENCES [dbo].[Tabla] ([Cd_Tab]) ON UPDATE CASCADE
GO
DENY DELETE ON  [dbo].[CampoTabla] TO [user321]
GO
