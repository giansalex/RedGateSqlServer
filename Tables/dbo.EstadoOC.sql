CREATE TABLE [dbo].[EstadoOC]
(
[Id_EstOC] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoOC] ADD CONSTRAINT [PK_EstadoOC] PRIMARY KEY CLUSTERED  ([Id_EstOC]) ON [PRIMARY]
GO
