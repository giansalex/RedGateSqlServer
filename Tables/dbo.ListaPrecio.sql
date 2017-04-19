CREATE TABLE [dbo].[ListaPrecio]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_LP] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [nvarchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descripcion] [nvarchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[RequiereAutorizacion] [bit] NULL,
[TieneFechaVigencia] [bit] NULL,
[PermiteModificacionPreciosVta] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecio] ADD CONSTRAINT [PK_ListaPrecio] PRIMARY KEY CLUSTERED  ([RucE], [Cd_LP]) ON [PRIMARY]
GO
