CREATE TABLE [dbo].[ListaPrecioDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_LP] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UMP] [int] NOT NULL,
[Desde] [numeric] (13, 3) NULL,
[Hasta] [numeric] (13, 3) NULL,
[Precio] [numeric] (13, 2) NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Dscto1] [decimal] (5, 4) NULL,
[Dscto2] [decimal] (5, 4) NULL,
[Dscto3] [decimal] (5, 4) NULL,
[FechaInicio] [smalldatetime] NULL,
[FechaFin] [smalldatetime] NULL,
[EsPorcentaje] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecioDet] ADD CONSTRAINT [PK_ListaPrecioDet_1] PRIMARY KEY CLUSTERED  ([RucE], [Cd_LP], [Cd_Prod], [UMP]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecioDet] ADD CONSTRAINT [FK_ListaPrecioDet_ListaPrecio1] FOREIGN KEY ([RucE], [Cd_LP]) REFERENCES [dbo].[ListaPrecio] ([RucE], [Cd_LP])
GO
ALTER TABLE [dbo].[ListaPrecioDet] ADD CONSTRAINT [FK_ListaPrecioDet_Moneda] FOREIGN KEY ([Cd_Mda]) REFERENCES [dbo].[Moneda] ([Cd_Mda])
GO
ALTER TABLE [dbo].[ListaPrecioDet] ADD CONSTRAINT [FK_ListaPrecioDet_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
ALTER TABLE [dbo].[ListaPrecioDet] ADD CONSTRAINT [FK_ListaPrecioDet_ProductoUMP] FOREIGN KEY ([RucE], [Cd_Prod], [UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
