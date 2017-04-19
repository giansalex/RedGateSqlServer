CREATE TABLE [dbo].[Tabla]
(
[Cd_Tab] [char] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (30) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ventana] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[EsCA] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tabla] ADD CONSTRAINT [PK_Tabla] PRIMARY KEY CLUSTERED  ([Cd_Tab]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la ventana', 'SCHEMA', N'dbo', 'TABLE', N'Tabla', 'COLUMN', N'Ventana'
GO
