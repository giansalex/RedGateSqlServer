CREATE TABLE [dbo].[EstadoOP]
(
[Id_EstOP] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoOP] ADD CONSTRAINT [PK_EstadoOP] PRIMARY KEY CLUSTERED  ([Id_EstOP]) ON [PRIMARY]
GO
