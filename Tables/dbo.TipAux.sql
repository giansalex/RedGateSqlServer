CREATE TABLE [dbo].[TipAux]
(
[Cd_TA] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipAux] ADD CONSTRAINT [PK_TipoAux] PRIMARY KEY CLUSTERED  ([Cd_TA]) ON [PRIMARY]
GO
