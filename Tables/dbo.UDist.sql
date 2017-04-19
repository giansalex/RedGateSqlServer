CREATE TABLE [dbo].[UDist]
(
[Cd_UDt] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UDist] ADD CONSTRAINT [PK_UDist] PRIMARY KEY CLUSTERED  ([Cd_UDt]) ON [PRIMARY]
GO
