CREATE TABLE [dbo].[DocsVou]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Id_Doc] [int] NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Titulo] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Img] [image] NULL,
[Ruta] [varchar] (256) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocsVou] ADD CONSTRAINT [PK_DocsVou] PRIMARY KEY CLUSTERED  ([RucE], [Id_Doc]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'DocsVou', 'COLUMN', N'Ruta'
GO
