CREATE TABLE [dbo].[OrdPedido]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OP] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroOP] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[FecE] [smalldatetime] NULL,
[Cd_FPC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vdr] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Cte] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DirecEnt] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[FecEnt] [smalldatetime] NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Valor] [numeric] (18, 7) NULL CONSTRAINT [DF_OrdPedido_Valor] DEFAULT ((0)),
[TotDsctoP] [numeric] (5, 2) NULL CONSTRAINT [DF_OrdPedido_DsctoP] DEFAULT ((0)),
[TotDsctoI] [numeric] (18, 7) NULL CONSTRAINT [DF_OrdPedido_DsctoI] DEFAULT ((0)),
[ValorNeto] [numeric] (18, 7) NULL CONSTRAINT [DF_OrdPedido_TotDsctoI1] DEFAULT ((0)),
[INF] [numeric] (18, 7) NULL CONSTRAINT [DF_OrdPedido_INF] DEFAULT ((0)),
[DsctoFnzInf_P] [numeric] (5, 2) NULL CONSTRAINT [DF_OrdPedido_DsctoFnzInf_P] DEFAULT ((0)),
[DsctoFnzInf_I] [numeric] (18, 7) NULL CONSTRAINT [DF_OrdPedido_DsctoFnzInf_I] DEFAULT ((0)),
[INF_Neto] [numeric] (18, 7) NULL CONSTRAINT [DF_OrdPedido_INF_Neto] DEFAULT ((0)),
[BIM] [numeric] (18, 7) NULL CONSTRAINT [DF_Orden_BIM] DEFAULT ((0)),
[DsctoFnzAf_P] [numeric] (5, 2) NULL CONSTRAINT [DF_OrdPedido_DsctoFnzAf_P] DEFAULT ((0)),
[DsctoFnzAf_I] [numeric] (18, 7) NULL CONSTRAINT [DF_OrdPedido_DsctoFnzAf_I] DEFAULT ((0)),
[BIM_Neto] [numeric] (18, 7) NULL,
[IGV] [numeric] (18, 7) NULL CONSTRAINT [DF_Orden_IGV] DEFAULT ((0)),
[Total] [numeric] (18, 7) NULL CONSTRAINT [DF_Orden_Total] DEFAULT ((0)),
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (6, 3) NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Id_EstOP] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Cot] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[TipAut] [int] NULL,
[IB_Aut] [bit] NULL,
[AutorizadoPor] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
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
[CA11] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA12] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA13] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA14] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA15] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Impreso] [bit] NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[FecVencimiento] [date] NULL,
[IB_Percepcion] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdPedido] ADD CONSTRAINT [PK_Orden] PRIMARY KEY CLUSTERED  ([RucE], [Cd_OP]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdPedido] ADD CONSTRAINT [IX_OrdPedido_Restric__RucE_NroOP] UNIQUE NONCLUSTERED  ([RucE], [NroOP]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdPedido] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedido_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
ALTER TABLE [dbo].[OrdPedido] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedido_Cotizacion] FOREIGN KEY ([RucE], [Cd_Cot]) REFERENCES [dbo].[Cotizacion] ([RucE], [Cd_Cot])
GO
ALTER TABLE [dbo].[OrdPedido] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedido_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[OrdPedido] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedido_EstadoOP] FOREIGN KEY ([Id_EstOP]) REFERENCES [dbo].[EstadoOP] ([Id_EstOP])
GO
ALTER TABLE [dbo].[OrdPedido] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedido_FormaPC] FOREIGN KEY ([Cd_FPC]) REFERENCES [dbo].[FormaPC] ([Cd_FPC])
GO
ALTER TABLE [dbo].[OrdPedido] WITH NOCHECK ADD CONSTRAINT [FK_OrdPedido_Vendedor2] FOREIGN KEY ([RucE], [Cd_Vdr]) REFERENCES [dbo].[Vendedor2] ([RucE], [Cd_Vdr])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ya no se debe usar', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'Cd_Cte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dscto Financiero  Afecto', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'DsctoFnzAf_I'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% Dscto Financiero Afecto', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'DsctoFnzAf_P'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dscto Financiero Inafecto', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'DsctoFnzInf_I'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% Dscto Financiero  Inafecto', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'DsctoFnzInf_P'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Emision', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'FecE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Entrega', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'FecEnt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Modifica', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'FecMdf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Registro', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'FecReg'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Autorizado', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'IB_Aut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Cotizacion', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'Id_EstOP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'INF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'INF_Neto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Autorizable', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'TipAut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Suma de los Dsctos x prod', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'TotDsctoI'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% de la Suma de los Dsctos x prod', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'TotDsctoP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'OrdPedido', 'COLUMN', N'ValorNeto'
GO
