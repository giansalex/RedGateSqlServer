CREATE TABLE [dbo].[OrdCompra]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OC] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroOC] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[FecE] [smalldatetime] NULL,
[FecEntR] [smalldatetime] NULL,
[Cd_FPC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prv] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Obs] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[Valor] [numeric] (13, 2) NULL CONSTRAINT [DF_OrdCompra_Valor] DEFAULT ((0)),
[TotDsctoP] [numeric] (5, 2) NULL CONSTRAINT [DF_OrdCompra_TotDsctoP] DEFAULT ((0)),
[TotDsctoI] [numeric] (13, 2) NULL CONSTRAINT [DF_OrdCompra_TotDsctoI] DEFAULT ((0)),
[ValorNeto] [numeric] (13, 2) NULL CONSTRAINT [DF_OrdCompra_ValorNeto] DEFAULT ((0)),
[DsctoFnzP] [numeric] (5, 2) NULL CONSTRAINT [DF_OrdCompra_DsctoFnzP] DEFAULT ((0)),
[DsctoFnzI] [numeric] (13, 2) NULL CONSTRAINT [DF_OrdCompra_DsctoFnzI] DEFAULT ((0)),
[BIM] [numeric] (13, 2) NULL CONSTRAINT [DF_OrdCompra_BIM] DEFAULT ((0)),
[IGV] [numeric] (13, 2) NULL CONSTRAINT [DF_OrdCompra_IGV] DEFAULT ((0)),
[Total] [numeric] (13, 2) NULL CONSTRAINT [DF_OrdCompra_Total] DEFAULT ((0)),
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (6, 3) NULL,
[IB_Aten] [bit] NULL,
[AutdoPorN1] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[AutdoPorN2] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[AutdoPorN3] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IC_NAut] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SCo] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Id_EstOC] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[TipAut] [int] NULL,
[IB_Aut] [bit] NULL,
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
[AutorizadoPor] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Asunto] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[CA11] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA12] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA13] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA14] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA15] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[Id_EstOCS] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Impreso] [bit] NULL,
[FecAPag] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdCompra] ADD CONSTRAINT [PK_OrdCompra] PRIMARY KEY CLUSTERED  ([RucE], [Cd_OC]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdCompra] ADD CONSTRAINT [IX_OrdCompra_Restric__RucE_NroOC] UNIQUE NONCLUSTERED  ([RucE], [NroOC]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdCompra] WITH NOCHECK ADD CONSTRAINT [FK_OrdCompra_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[OrdCompra] WITH NOCHECK ADD CONSTRAINT [FK_OrdCompra_EstadoOC] FOREIGN KEY ([Id_EstOC]) REFERENCES [dbo].[EstadoOC] ([Id_EstOC])
GO
ALTER TABLE [dbo].[OrdCompra] ADD CONSTRAINT [FK_OrdCompra_EstadoOC_Srv] FOREIGN KEY ([Id_EstOCS]) REFERENCES [dbo].[EstadoOC_Srv] ([Id_EstOCS])
GO
ALTER TABLE [dbo].[OrdCompra] WITH NOCHECK ADD CONSTRAINT [FK_OrdCompra_FormaPC] FOREIGN KEY ([Cd_FPC]) REFERENCES [dbo].[FormaPC] ([Cd_FPC])
GO
ALTER TABLE [dbo].[OrdCompra] WITH NOCHECK ADD CONSTRAINT [FK_OrdCompra_SolicitudCom] FOREIGN KEY ([RucE], [Cd_SCo]) REFERENCES [dbo].[SolicitudCom] ([RucE], [Cd_SCo])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Autorizado Por Nivel 1', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'AutdoPorN1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Forma Pago/Cobro', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'Cd_FPC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OC00000001', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'Cd_OC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Proveedor', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'Cd_Prv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dscto Financiero', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'DsctoFnzI'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% Dscto Financiero', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'DsctoFnzP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Emision', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'FecE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fec. de Entrega Requerida', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'FecEntR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Autorizado', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'IB_Aut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Autorizado (Puede ser: 1, 2, 3)', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'IC_NAut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Orden de Compra', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'Id_EstOC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Orden de Compra para Servicios', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'Id_EstOCS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Autorizable', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'TipAut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Suma de los Dsctos x prod', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'TotDsctoI'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% de la Suma de los Dsctos x prod', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'TotDsctoP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Suma de los BIM detalle', 'SCHEMA', N'dbo', 'TABLE', N'OrdCompra', 'COLUMN', N'ValorNeto'
GO
