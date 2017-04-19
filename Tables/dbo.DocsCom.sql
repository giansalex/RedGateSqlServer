CREATE TABLE [dbo].[DocsCom]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Id_Doc] [int] NOT NULL,
[Cd_Com] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Titulo] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Img] [image] NULL,
[Ruta] [varchar] (256) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocsCom] ADD CONSTRAINT [PK_DocsCom] PRIMARY KEY CLUSTERED  ([RucE], [Id_Doc]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocsCom] ADD CONSTRAINT [FK_DocsCom_Compra] FOREIGN KEY ([RucE], [Cd_Com]) REFERENCES [dbo].[Compra] ([RucE], [Cd_Com])
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'DocsCom', 'COLUMN', N'Ruta'
GO
