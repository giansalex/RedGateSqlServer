CREATE TABLE [dbo].[Menu]
(
[Cd_MN] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ImgIdx] [smallint] NULL,
[Estado] [bit] NOT NULL,
[IB_Web] [bit] NULL,
[Ruta] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Menu] ADD CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED  ([Cd_MN]) ON [PRIMARY]
GO
