CREATE TABLE [dbo].[DocsVta]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Id_Doc] [int] NOT NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Titulo] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Img] [image] NULL,
[Ruta] [varchar] (256) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocsVta] ADD CONSTRAINT [PK_DocsVta] PRIMARY KEY CLUSTERED  ([RucE], [Id_Doc]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocsVta] WITH NOCHECK ADD CONSTRAINT [FK_DocsVta_Venta] FOREIGN KEY ([RucE], [Cd_Vta]) REFERENCES [dbo].[Venta] ([RucE], [Cd_Vta])
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'DocsVta', 'COLUMN', N'Ruta'
GO
