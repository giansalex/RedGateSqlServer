CREATE TABLE [dbo].[CampoT]
(
[Cd_TC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CampoT] ADD CONSTRAINT [PK_CampoTipo] PRIMARY KEY CLUSTERED  ([Cd_TC]) ON [PRIMARY]
GO
DENY REFERENCES ON  [dbo].[CampoT] TO [User123]
GO
DENY INSERT ON  [dbo].[CampoT] TO [User123]
GO
DENY DELETE ON  [dbo].[CampoT] TO [User123]
GO
DENY UPDATE ON  [dbo].[CampoT] TO [User123]
GO
