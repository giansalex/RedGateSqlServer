CREATE TABLE [dbo].[EstadoSC_Srv]
(
[Id_EstSCS] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoSC_Srv] ADD CONSTRAINT [PK_EstadoSC_Srv] PRIMARY KEY CLUSTERED  ([Id_EstSCS]) ON [PRIMARY]
GO
