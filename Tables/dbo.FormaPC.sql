CREATE TABLE [dbo].[FormaPC]
(
[Cd_FPC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FormaPC] ADD CONSTRAINT [PK_FormaPC] PRIMARY KEY CLUSTERED  ([Cd_FPC]) ON [PRIMARY]
GO
