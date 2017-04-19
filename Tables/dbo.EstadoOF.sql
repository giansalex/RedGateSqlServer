CREATE TABLE [dbo].[EstadoOF]
(
[Id_EstOF] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoOF] ADD CONSTRAINT [PK_EstadoOF] PRIMARY KEY CLUSTERED  ([Id_EstOF]) ON [PRIMARY]
GO
