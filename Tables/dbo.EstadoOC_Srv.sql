CREATE TABLE [dbo].[EstadoOC_Srv]
(
[Id_EstOCS] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoOC_Srv] ADD CONSTRAINT [PK_EstadoOC_Srv] PRIMARY KEY CLUSTERED  ([Id_EstOCS]) ON [PRIMARY]
GO
