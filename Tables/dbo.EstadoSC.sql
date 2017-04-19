CREATE TABLE [dbo].[EstadoSC]
(
[Id_EstSC] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoSC] ADD CONSTRAINT [PK_EstadoSC] PRIMARY KEY CLUSTERED  ([Id_EstSC]) ON [PRIMARY]
GO
