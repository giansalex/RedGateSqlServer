CREATE TABLE [dbo].[Fuente]
(
[Cd_Fte] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Fuente] ADD CONSTRAINT [PK_Fuente] PRIMARY KEY CLUSTERED  ([Cd_Fte]) ON [PRIMARY]
GO
