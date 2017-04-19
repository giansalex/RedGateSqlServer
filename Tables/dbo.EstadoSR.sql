CREATE TABLE [dbo].[EstadoSR]
(
[Id_EstSR] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoSR] ADD CONSTRAINT [PK_EstadoSR] PRIMARY KEY CLUSTERED  ([Id_EstSR]) ON [PRIMARY]
GO
