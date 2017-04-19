CREATE TABLE [dbo].[EstadoCot]
(
[Id_EstC] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoCot] ADD CONSTRAINT [PK_EstadoCot] PRIMARY KEY CLUSTERED  ([Id_EstC]) ON [PRIMARY]
GO
