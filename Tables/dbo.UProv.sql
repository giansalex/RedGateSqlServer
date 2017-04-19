CREATE TABLE [dbo].[UProv]
(
[Cd_UPv] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UProv] ADD CONSTRAINT [PK_UProv] PRIMARY KEY CLUSTERED  ([Cd_UPv]) ON [PRIMARY]
GO
