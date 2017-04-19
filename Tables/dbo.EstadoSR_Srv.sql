CREATE TABLE [dbo].[EstadoSR_Srv]
(
[Id_EstSRS] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoSR_Srv] ADD CONSTRAINT [PK_EstadoSR_Srv] PRIMARY KEY CLUSTERED  ([Id_EstSRS]) ON [PRIMARY]
GO
