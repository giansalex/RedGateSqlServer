CREATE TABLE [dbo].[ProdProvPrecio]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_PrecPrv] [int] NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Fecha] [smalldatetime] NOT NULL,
[PrecioCom] [numeric] (13, 2) NOT NULL,
[IB_IncIGV] [bit] NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProdProvPrecio] ADD CONSTRAINT [PK_ProdProvPrecio] PRIMARY KEY CLUSTERED  ([RucE], [ID_PrecPrv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProdProvPrecio] ADD CONSTRAINT [IX_ProdProvPrecio_RucE_Pv_Pd_UM_Fec] UNIQUE NONCLUSTERED  ([RucE], [Cd_Prv], [Cd_Prod], [ID_UMP], [Fecha]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProdProvPrecio] ADD CONSTRAINT [FK_ProdProvPrecio_ProdProv] FOREIGN KEY ([RucE], [Cd_Prv], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[ProdProv] ([RucE], [Cd_Prv], [Cd_Prod], [ID_UMP])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Precio incluia IGV', 'SCHEMA', N'dbo', 'TABLE', N'ProdProvPrecio', 'COLUMN', N'IB_IncIGV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id interno de precio proveedor', 'SCHEMA', N'dbo', 'TABLE', N'ProdProvPrecio', 'COLUMN', N'ID_PrecPrv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descuentos, ofertas, otros', 'SCHEMA', N'dbo', 'TABLE', N'ProdProvPrecio', 'COLUMN', N'Obs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Precio de Compra', 'SCHEMA', N'dbo', 'TABLE', N'ProdProvPrecio', 'COLUMN', N'PrecioCom'
GO
