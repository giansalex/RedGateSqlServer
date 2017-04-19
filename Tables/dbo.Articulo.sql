CREATE TABLE [dbo].[Articulo]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Art] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cat] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Ln] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_UM] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Mca] [nvarchar] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Img] [image] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Articulo] ADD CONSTRAINT [PK_Articulo] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Art]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Articulo] WITH NOCHECK ADD CONSTRAINT [FK_Articulo_Categoria] FOREIGN KEY ([Cd_Cat]) REFERENCES [dbo].[Categoria] ([Cd_Cat])
GO
ALTER TABLE [dbo].[Articulo] WITH NOCHECK ADD CONSTRAINT [FK_Articulo_Linea] FOREIGN KEY ([Cd_Ln]) REFERENCES [dbo].[Linea] ([Cd_Ln])
GO
ALTER TABLE [dbo].[Articulo] WITH NOCHECK ADD CONSTRAINT [FK_Articulo_Producto] FOREIGN KEY ([RucE], [Cd_Art]) REFERENCES [dbo].[Producto] ([RucE], [Cd_Pro]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Articulo] WITH NOCHECK ADD CONSTRAINT [FK_Articulo_UnidadMedida] FOREIGN KEY ([Cd_UM]) REFERENCES [dbo].[UnidadMedida] ([Cd_UM])
GO
