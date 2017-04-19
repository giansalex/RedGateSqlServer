CREATE TABLE [dbo].[Venta]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Eje] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Prdo] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMov] [smalldatetime] NOT NULL,
[Cd_FPC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[FecCbr] [smalldatetime] NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroSre] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Sr_NO] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Num_NO] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NULL,
[FecED] [smalldatetime] NULL,
[FecVD] [smalldatetime] NULL,
[Cd_Cte_NO] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vdr_NO] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Valor] [numeric] (13, 2) NULL CONSTRAINT [DF_Venta_Valor] DEFAULT ((0)),
[TotDsctoP] [numeric] (5, 2) NULL CONSTRAINT [DF_Venta_TotDsctoP] DEFAULT ((0)),
[TotDsctoI] [numeric] (13, 2) NULL CONSTRAINT [DF_Venta_TotDsctoI] DEFAULT ((0)),
[ValorNeto] [numeric] (13, 2) NULL CONSTRAINT [DF_Venta_ValorNeto] DEFAULT ((0)),
[BaseSinDsctoF] [numeric] (13, 2) NULL CONSTRAINT [DF_Venta_INF1] DEFAULT ((0)),
[DsctoFnz_P] [numeric] (5, 2) NULL CONSTRAINT [DF_Venta_DsctoFnzP] DEFAULT ((0)),
[DsctoFnz_I] [numeric] (13, 2) NULL CONSTRAINT [DF_Venta_DsctoFnzI] DEFAULT ((0)),
[Cd_IAV_DF] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[INF_Neto] [numeric] (13, 2) NULL CONSTRAINT [DF_Venta_INF] DEFAULT ((0)),
[EXO_Neto] [numeric] (13, 2) NULL CONSTRAINT [DF_Venta_EXO] DEFAULT ((0)),
[EXPO_Neto] [numeric] (13, 2) NULL CONSTRAINT [DF_Venta_EXO_Neto1] DEFAULT ((0)),
[BIM_Neto] [numeric] (13, 2) NULL CONSTRAINT [DF_Venta_BIM1] DEFAULT ((0)),
[IGV] [numeric] (13, 2) NULL CONSTRAINT [DF_Venta_IGV] DEFAULT ((0)),
[Total] [numeric] (13, 2) NOT NULL CONSTRAINT [DF_Venta_Total] DEFAULT ((0)),
[Percep] [numeric] (18, 7) NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CamMda] [numeric] (6, 3) NOT NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Anulado] [bit] NOT NULL,
[IB_Cbdo] [bit] NULL,
[DR_CdVta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[DR_FecED] [smalldatetime] NULL,
[DR_CdTD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[DR_NSre] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[DR_NDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA11] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA12] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA13] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA14] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA15] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_OP] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[NroOP] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_MIS] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vdr] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[CostoTot] [numeric] (13, 2) NULL,
[CA16] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA17] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA18] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA19] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA20] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA21] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA22] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA23] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA24] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA25] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Impreso] [bit] NULL,
[IB_TieneRetencion] [bit] NULL,
[Monto_Retencion] [numeric] (20, 7) NULL,
[DireccionFacturacion] [nvarchar] (400) COLLATE Modern_Spanish_CI_AS NULL CONSTRAINT [DF__Venta__Direccion__7F3D2ADF] DEFAULT (''),
[FirmaDgt] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[DE_EstEnvSNT] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[DE_FecEnvSNT] [date] NULL,
[DE_EstEnvClt] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[DE_FirmaDgt] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[DE_XML] [xml] NULL,
[DE_CDR] [varbinary] (max) NULL,
[MtvoBaja] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Venta] ADD CONSTRAINT [PK_Venta] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Vta]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Venta] ADD CONSTRAINT [IX_Vta_Restriccio3_CdTD_NroSre_NroDoc] UNIQUE NONCLUSTERED  ([RucE], [Cd_TD], [NroSre], [NroDoc]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Venta] ADD CONSTRAINT [IX_Vta_Restriccio1_Reg_Contable] UNIQUE NONCLUSTERED  ([RucE], [Eje], [Prdo], [RegCtb]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Venta] ADD CONSTRAINT [IX_Vta_Restriccio2_Reg_Contable] UNIQUE NONCLUSTERED  ([RucE], [Eje], [RegCtb]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK ADD CONSTRAINT [FK_Venta_Area] FOREIGN KEY ([RucE], [Cd_Area]) REFERENCES [dbo].[Area] ([RucE], [Cd_Area])
GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK ADD CONSTRAINT [FK_Venta_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
ALTER TABLE [dbo].[Venta] ADD CONSTRAINT [FK_Venta_EstEnvClt] FOREIGN KEY ([DE_EstEnvClt]) REFERENCES [dbo].[EstEnvClt] ([Id_EstEnvClt])
GO
ALTER TABLE [dbo].[Venta] ADD CONSTRAINT [FK_Venta_EstEnvSNT] FOREIGN KEY ([DE_EstEnvSNT]) REFERENCES [dbo].[EstEnvSNT] ([Id_EstEnvSNT])
GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK ADD CONSTRAINT [FK_Venta_FormaPC] FOREIGN KEY ([Cd_FPC]) REFERENCES [dbo].[FormaPC] ([Cd_FPC])
GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK ADD CONSTRAINT [FK_Venta_Modulo] FOREIGN KEY ([Cd_MR]) REFERENCES [dbo].[Modulo] ([Cd_MR])
GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK ADD CONSTRAINT [FK_Venta_Moneda] FOREIGN KEY ([Cd_Mda]) REFERENCES [dbo].[Moneda] ([Cd_Mda])
GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK ADD CONSTRAINT [FK_Venta_OrdPedido] FOREIGN KEY ([RucE], [Cd_OP]) REFERENCES [dbo].[OrdPedido] ([RucE], [Cd_OP])
GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK ADD CONSTRAINT [FK_Venta_Periodo] FOREIGN KEY ([RucE], [Eje]) REFERENCES [dbo].[Periodo] ([RucE], [Ejer])
GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK ADD CONSTRAINT [FK_Venta_Serie] FOREIGN KEY ([RucE], [Cd_Sr_NO]) REFERENCES [dbo].[Serie] ([RucE], [Cd_Sr])
GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK ADD CONSTRAINT [FK_Venta_TipDoc] FOREIGN KEY ([Cd_TD]) REFERENCES [dbo].[TipDoc] ([Cd_TD])
GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK ADD CONSTRAINT [FK_Venta_Vendedor2] FOREIGN KEY ([RucE], [Cd_Vdr]) REFERENCES [dbo].[Vendedor2] ([RucE], [Cd_Vdr])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Puede ser EXPO, EXO, INF, BIM', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'BaseSinDsctoF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Base Imponible', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'BIM_Neto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'YA NO SE USA', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'Cd_Cte_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Afecto - Dscto Financiero', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'Cd_IAV_DF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'YA NO SE USA', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'Cd_Num_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'YA NO SE USA', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'Cd_Sr_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'YA NO SE USA', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'Cd_Vdr_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Doc. Electronico: Estado Envio Cliente', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'DE_EstEnvClt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Doc. Electronico: Estado Envio Sunat', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'DE_EstEnvSNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Doc. Electronico: FechaEnvio Sunat', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'DE_FecEnvSNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dscto Financiero Inafecto', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'DsctoFnz_I'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% Dscto Financiero Inafecto', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'DsctoFnz_P'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Exonerado', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'EXO_Neto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor Exportacion', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'EXPO_Neto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha a Cobrar', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'FecCbr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inafecto', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'INF_Neto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Motivo por el cual se anuló o dió de baja este docuemento', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'MtvoBaja'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Percepcion', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'Percep'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Suma de los Dsctos x prod', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'TotDsctoI'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% de la Suma de los Dsctos x prod', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'TotDsctoP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Irrelevante contablemente', 'SCHEMA', N'dbo', 'TABLE', N'Venta', 'COLUMN', N'ValorNeto'
GO
