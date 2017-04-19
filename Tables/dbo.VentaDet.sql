CREATE TABLE [dbo].[VentaDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nro_RegVdt] [int] NOT NULL,
[Cd_Pro_NO] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NULL CONSTRAINT [DF_VentaDet_Cd_Pro] DEFAULT ((0)),
[Cant] [numeric] (16, 7) NULL,
[Cd_UM_NO] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Valor] [numeric] (16, 7) NULL,
[DsctoP] [numeric] (5, 2) NULL,
[DsctoI] [numeric] (16, 7) NULL,
[IMP] [numeric] (16, 7) NULL,
[IGV] [numeric] (16, 7) NULL,
[Total] [numeric] (16, 7) NULL,
[CA01] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[PU] [numeric] (16, 7) NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_IAV] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[CU] [numeric] (16, 7) NULL,
[Costo] [numeric] (16, 7) NULL,
[CU_ME] [numeric] (16, 7) NULL,
[Costo_ME] [numeric] (16, 7) NULL,
[UsuMdfCostoPrm] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[ValVtaUnit] [numeric] (18, 7) NULL,
[TotalVtaSD] [numeric] (20, 7) NULL,
[PrecioUnitSD] [numeric] (18, 7) NULL,
[PercepPorc] [numeric] (8, 7) NULL,
[PercepImporte] [numeric] (16, 7) NULL,
[TotalNeto] [numeric] (18, 7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VentaDet] ADD CONSTRAINT [PK_VentaDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Vta], [Nro_RegVdt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VentaDet] ADD CONSTRAINT [IX_VentaDet] UNIQUE NONCLUSTERED  ([RucE], [Cd_Vta], [Nro_RegVdt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VentaDet] WITH NOCHECK ADD CONSTRAINT [FK_VentaDet_Almacen] FOREIGN KEY ([RucE], [Cd_Alm]) REFERENCES [dbo].[Almacen] ([RucE], [Cd_Alm])
GO
ALTER TABLE [dbo].[VentaDet] WITH NOCHECK ADD CONSTRAINT [FK_VentaDet_CCostos] FOREIGN KEY ([RucE], [Cd_CC]) REFERENCES [dbo].[CCostos] ([RucE], [Cd_CC])
GO
ALTER TABLE [dbo].[VentaDet] WITH NOCHECK ADD CONSTRAINT [FK_VentaDet_CCSub] FOREIGN KEY ([RucE], [Cd_CC], [Cd_SC]) REFERENCES [dbo].[CCSub] ([RucE], [Cd_CC], [Cd_SC])
GO
ALTER TABLE [dbo].[VentaDet] WITH NOCHECK ADD CONSTRAINT [FK_VentaDet_CCSubSub] FOREIGN KEY ([RucE], [Cd_CC], [Cd_SC], [Cd_SS]) REFERENCES [dbo].[CCSubSub] ([RucE], [Cd_CC], [Cd_SC], [Cd_SS])
GO
ALTER TABLE [dbo].[VentaDet] ADD CONSTRAINT [FK_VentaDet_IndicadorAfectoVta] FOREIGN KEY ([Cd_IAV]) REFERENCES [dbo].[IndicadorAfectoVta] ([Cd_IAV])
GO
ALTER TABLE [dbo].[VentaDet] ADD CONSTRAINT [FK_VentaDet_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[VentaDet] WITH NOCHECK ADD CONSTRAINT [FK_VentaDet_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
ALTER TABLE [dbo].[VentaDet] WITH NOCHECK ADD CONSTRAINT [FK_VentaDet_Servicio2] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
ALTER TABLE [dbo].[VentaDet] WITH NOCHECK ADD CONSTRAINT [FK_VentaDet_UnidadMedida] FOREIGN KEY ([Cd_UM_NO]) REFERENCES [dbo].[UnidadMedida] ([Cd_UM])
GO
ALTER TABLE [dbo].[VentaDet] WITH NOCHECK ADD CONSTRAINT [FK_VentaDet_Venta] FOREIGN KEY ([RucE], [Cd_Vta]) REFERENCES [dbo].[Venta] ([RucE], [Cd_Vta]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Almacen', 'SCHEMA', N'dbo', 'TABLE', N'VentaDet', 'COLUMN', N'Cd_Alm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'VentaDet', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Indicador Afecto Venta', 'SCHEMA', N'dbo', 'TABLE', N'VentaDet', 'COLUMN', N'Cd_IAV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'YA NO SE USA', 'SCHEMA', N'dbo', 'TABLE', N'VentaDet', 'COLUMN', N'Cd_Pro_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'VentaDet', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRV0001', 'SCHEMA', N'dbo', 'TABLE', N'VentaDet', 'COLUMN', N'Cd_Srv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'VentaDet', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'YA NO SE USA', 'SCHEMA', N'dbo', 'TABLE', N'VentaDet', 'COLUMN', N'Cd_UM_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CU * Cant', 'SCHEMA', N'dbo', 'TABLE', N'VentaDet', 'COLUMN', N'Costo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrip para prod. no propios', 'SCHEMA', N'dbo', 'TABLE', N'VentaDet', 'COLUMN', N'Descrip'
GO
