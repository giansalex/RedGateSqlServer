CREATE TABLE [dbo].[Cotizacion]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cot] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroCot] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[FecEmi] [smalldatetime] NOT NULL,
[FecCad] [smalldatetime] NULL,
[Cd_FPC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Asunto] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Cte] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vdr] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CostoTot] [numeric] (13, 2) NULL,
[Valor] [numeric] (13, 2) NULL CONSTRAINT [DF_Cotizacion2_Valor] DEFAULT ((0)),
[TotDsctoP] [numeric] (5, 2) NULL CONSTRAINT [DF_Cotizacion2_DsctoP] DEFAULT ((0)),
[TotDsctoI] [numeric] (13, 2) NULL CONSTRAINT [DF_Cotizacion2_DsctoI] DEFAULT ((0)),
[INF] [numeric] (13, 2) NULL CONSTRAINT [DF_Cotizacion_INF1] DEFAULT ((0)),
[DsctoFnzInf_P] [numeric] (5, 2) NULL CONSTRAINT [DF_Cotizacion_DsctoP1] DEFAULT ((0)),
[DsctoFnzInf_I] [numeric] (13, 2) NULL CONSTRAINT [DF_Cotizacion_DsctoI1] DEFAULT ((0)),
[INF_Neto] [numeric] (13, 2) NULL CONSTRAINT [DF_Cotizacion_INF] DEFAULT ((0)),
[BIM] [numeric] (13, 2) NULL,
[DsctoFnzAf_P] [numeric] (5, 2) NULL CONSTRAINT [DF_Cotizacion_DsctoFnzP1] DEFAULT ((0)),
[DsctoFnzAf_I] [numeric] (13, 2) NULL CONSTRAINT [DF_Cotizacion_DsctoFnzI1] DEFAULT ((0)),
[BIM_Neto] [numeric] (13, 2) NULL,
[IGV] [numeric] (13, 2) NULL CONSTRAINT [DF_Cotizacion2_IGV] DEFAULT ((0)),
[Total] [numeric] (13, 2) NULL CONSTRAINT [DF_Cotizacion2_Total] DEFAULT ((0)),
[MU_Porc] [numeric] (13, 2) NULL,
[MU_Imp] [numeric] (13, 2) NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (6, 3) NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CdCot_Base] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Id_EstC] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_FCt] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[TipAut] [int] NULL,
[IB_Aut] [bit] NULL,
[AutorizadoPor] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
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
[IB_Percepcion] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cotizacion] ADD CONSTRAINT [PK_Cotizacion2] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Cot]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cotizacion] ADD CONSTRAINT [IX_Cotizacion_Restric__Ruc_NroCot] UNIQUE NONCLUSTERED  ([RucE], [NroCot]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cotizacion] WITH NOCHECK ADD CONSTRAINT [FK_Cotizacion_Cliente] FOREIGN KEY ([RucE], [Cd_Cte]) REFERENCES [dbo].[Cliente] ([RucE], [Cd_Aux])
GO
ALTER TABLE [dbo].[Cotizacion] WITH NOCHECK ADD CONSTRAINT [FK_Cotizacion_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
ALTER TABLE [dbo].[Cotizacion] WITH NOCHECK ADD CONSTRAINT [FK_Cotizacion_Cotizacion] FOREIGN KEY ([RucE], [CdCot_Base]) REFERENCES [dbo].[Cotizacion] ([RucE], [Cd_Cot])
GO
ALTER TABLE [dbo].[Cotizacion] WITH NOCHECK ADD CONSTRAINT [FK_Cotizacion_CotizacionFormato] FOREIGN KEY ([RucE], [Cd_FCt]) REFERENCES [dbo].[CotizacionFormato] ([RucE], [Cd_FCt])
GO
ALTER TABLE [dbo].[Cotizacion] WITH NOCHECK ADD CONSTRAINT [FK_Cotizacion_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[Cotizacion] WITH NOCHECK ADD CONSTRAINT [FK_Cotizacion_EstadoCot] FOREIGN KEY ([Id_EstC]) REFERENCES [dbo].[EstadoCot] ([Id_EstC])
GO
ALTER TABLE [dbo].[Cotizacion] WITH NOCHECK ADD CONSTRAINT [FK_Cotizacion_FormaPC] FOREIGN KEY ([Cd_FPC]) REFERENCES [dbo].[FormaPC] ([Cd_FPC])
GO
ALTER TABLE [dbo].[Cotizacion] WITH NOCHECK ADD CONSTRAINT [FK_Cotizacion_Vendedor2] FOREIGN KEY ([RucE], [Cd_Vdr]) REFERENCES [dbo].[Vendedor2] ([RucE], [Cd_Vdr])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Cliente 2', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'Cd_Clt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CT00000001', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'Cd_Cot'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Cliente', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'Cd_Cte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Formato Cotizacion', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'Cd_FCt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cotizacion que modifica', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'CdCot_Base'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dscto Financiero  Afecto', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'DsctoFnzAf_I'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% Dscto Financiero Afecto', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'DsctoFnzAf_P'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dscto Financiero Inafecto', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'DsctoFnzInf_I'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% Dscto Financiero  Inafecto', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'DsctoFnzInf_P'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha que caduca o expira  la Cot.', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'FecCad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Autorizado', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'IB_Aut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Cotizacion', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'Id_EstC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'INF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'INF_Neto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Margen Utilidad Importe GANADO', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'MU_Imp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Margen Utilidad Porcentual GANADO', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'MU_Porc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'NroCot'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Autorizable', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'TipAut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Suma de los Dsctos x prod', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'TotDsctoI'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% de la Suma de los Dsctos x prod', 'SCHEMA', N'dbo', 'TABLE', N'Cotizacion', 'COLUMN', N'TotDsctoP'
GO
