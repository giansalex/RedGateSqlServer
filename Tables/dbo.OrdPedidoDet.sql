CREATE TABLE [dbo].[OrdPedidoDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OP] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[PU] [numeric] (18, 9) NULL,
[Cant] [numeric] (18, 9) NULL,
[Valor] [numeric] (18, 9) NULL,
[DsctoP] [numeric] (5, 2) NULL,
[DsctoI] [numeric] (18, 9) NULL,
[BIM] [numeric] (18, 9) NULL,
[IGV] [numeric] (18, 9) NULL,
[Total] [numeric] (18, 9) NULL,
[PendEnt] [numeric] (18, 9) NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[ValVtaUnit] [numeric] (18, 7) NULL,
[TotalVtaSD] [numeric] (20, 7) NULL,
[PrecioUnitSD] [numeric] (18, 7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdPedidoDet] ADD CONSTRAINT [PK_OrdPedidoDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_OP], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdPedidoDet] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedidoDet_Almacen] FOREIGN KEY ([RucE], [Cd_Alm]) REFERENCES [dbo].[Almacen] ([RucE], [Cd_Alm])
GO
ALTER TABLE [dbo].[OrdPedidoDet] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedidoDet_OrdPedido] FOREIGN KEY ([RucE], [Cd_OP]) REFERENCES [dbo].[OrdPedido] ([RucE], [Cd_OP])
GO
ALTER TABLE [dbo].[OrdPedidoDet] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedidoDet_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[OrdPedidoDet] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedidoDet_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
ALTER TABLE [dbo].[OrdPedidoDet] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedidoDet_Servicio2] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
ALTER TABLE [dbo].[OrdPedidoDet] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedidoDet_Servicio21] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedidoDet', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedidoDet', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRV0001', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedidoDet', 'COLUMN', N'Cd_Srv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedidoDet', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrip para prod. no propios', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedidoDet', 'COLUMN', N'Descrip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pendientes x Entregar', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedidoDet', 'COLUMN', N'PendEnt'
GO
