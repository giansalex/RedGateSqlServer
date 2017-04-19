CREATE TABLE [dbo].[CotizacionDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cot] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_CtD] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[ID_Prec] [int] NULL,
[ID_PrSv] [int] NULL,
[CU] [numeric] (18, 7) NULL,
[Costo] [numeric] (18, 7) NULL,
[PU] [numeric] (18, 7) NULL CONSTRAINT [DF_CotizacionDet_Valor2] DEFAULT ((0)),
[Cant] [numeric] (18, 7) NULL CONSTRAINT [DF_CotizacionDet_Valor1] DEFAULT ((0)),
[Valor] [numeric] (18, 7) NULL CONSTRAINT [DF_CotizacionDet_Valor] DEFAULT ((0)),
[DsctoP] [numeric] (5, 2) NULL CONSTRAINT [DF_CotizacionDet_DsctoP] DEFAULT ((0)),
[DsctoI] [numeric] (18, 7) NULL CONSTRAINT [DF_CotizacionDet_DsctoI] DEFAULT ((0)),
[BIM] [numeric] (18, 7) NULL,
[IGV] [numeric] (18, 7) NULL CONSTRAINT [DF_CotizacionDet_IGV] DEFAULT ((0)),
[Total] [numeric] (18, 7) NULL CONSTRAINT [DF_CotizacionDet_Total] DEFAULT ((0)),
[MU_Porc] [numeric] (13, 2) NULL,
[MU_Imp] [numeric] (18, 7) NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CotizacionDet] ADD CONSTRAINT [PK_CotizacionDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Cot], [ID_CtD]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CotizacionDet] WITH NOCHECK ADD CONSTRAINT [FK_CotizacionDet_Cotizacion] FOREIGN KEY ([RucE], [Cd_Cot]) REFERENCES [dbo].[Cotizacion] ([RucE], [Cd_Cot])
GO
ALTER TABLE [dbo].[CotizacionDet] WITH NOCHECK ADD CONSTRAINT [FK_CotizacionDet_Precio] FOREIGN KEY ([RucE], [ID_Prec]) REFERENCES [dbo].[Precio] ([RucE], [ID_Prec])
GO
ALTER TABLE [dbo].[CotizacionDet] WITH NOCHECK ADD CONSTRAINT [FK_CotizacionDet_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[CotizacionDet] WITH NOCHECK ADD CONSTRAINT [FK_CotizacionDet_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
ALTER TABLE [dbo].[CotizacionDet] WITH NOCHECK ADD CONSTRAINT [FK_CotizacionDet_Servicio2] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRV0001', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'Cd_Srv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CU * Cant', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'Costo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrip para prod. no propios', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'Descrip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id Precio Producto', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'ID_Prec'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id Precio Servicio', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'ID_PrSv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Margen Utilidad Importe', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'MU_Imp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Margen Utilidad Porcentual', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'MU_Porc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'CotizacionDet', 'COLUMN', N'RucE'
GO
