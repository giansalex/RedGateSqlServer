CREATE TABLE [dbo].[ListaPrecio_Vendedores]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_LP] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vdr] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecio_Vendedores] ADD CONSTRAINT [PK_ListaPrecio_Vendedores] PRIMARY KEY CLUSTERED  ([RucE], [Cd_LP], [Cd_Vdr]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecio_Vendedores] ADD CONSTRAINT [FK_ListaPrecio_Vendedores_ListaPrecio] FOREIGN KEY ([RucE], [Cd_LP]) REFERENCES [dbo].[ListaPrecio] ([RucE], [Cd_LP])
GO
ALTER TABLE [dbo].[ListaPrecio_Vendedores] ADD CONSTRAINT [FK_ListaPrecio_Vendedores_Vendedor2] FOREIGN KEY ([RucE], [Cd_Vdr]) REFERENCES [dbo].[Vendedor2] ([RucE], [Cd_Vdr])
GO
