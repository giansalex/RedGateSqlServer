CREATE TABLE [dbo].[UDepa]
(
[Cd_UDp] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UDepa] ADD CONSTRAINT [PK_UDepa] PRIMARY KEY CLUSTERED  ([Cd_UDp]) ON [PRIMARY]
GO
