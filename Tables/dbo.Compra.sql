CREATE TABLE [dbo].[Compra]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Com] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL CONSTRAINT [DF_Compra_Cd_Com] DEFAULT (N'Codigo Compra'),
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Prdo] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMov] [smalldatetime] NOT NULL,
[Cd_FPC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[FecAPag] [smalldatetime] NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroSre] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecED] [smalldatetime] NULL,
[FecVD] [smalldatetime] NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_MR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[BIM_S] [numeric] (13, 2) NULL CONSTRAINT [DF_Compra_BIM] DEFAULT ((0)),
[IGV_S] [numeric] (13, 2) NULL CONSTRAINT [DF_Compra_IGV] DEFAULT ((0)),
[BIM_E] [numeric] (13, 2) NULL CONSTRAINT [DF_Compra_BIM1] DEFAULT ((0)),
[IGV_E] [numeric] (13, 2) NULL CONSTRAINT [DF_Compra_IGV1] DEFAULT ((0)),
[BIM_C] [numeric] (13, 2) NULL CONSTRAINT [DF_Compra_BIM2] DEFAULT ((0)),
[IGV_C] [numeric] (13, 2) NULL CONSTRAINT [DF_Compra_IGV2] DEFAULT ((0)),
[Imp_N] [numeric] (13, 2) NULL CONSTRAINT [DF_Compra_BIM_C1] DEFAULT ((0)),
[Imp_O] [numeric] (13, 0) NULL,
[Total] [numeric] (13, 2) NOT NULL CONSTRAINT [DF_Compra_Total] DEFAULT ((0)),
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CamMda] [numeric] (6, 3) NOT NULL,
[Cd_MIS] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_OC] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Pgdo] [bit] NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Anulado] [bit] NOT NULL,
[DR_NCND] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[DR_NroDet] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[DR_FecDet] [smalldatetime] NULL,
[DR_CdCom] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[DR_FecED] [smalldatetime] NULL,
[DR_CdTD] [varchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[DR_NSre] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[DR_NDoc] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
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
[TipNC] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[ImpDetr] [numeric] (13, 2) NULL,
[FecPagDtr] [datetime] NULL,
[ImpDetr_ME] [numeric] (13, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Compra] ADD CONSTRAINT [PK_Compra] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Com]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Compra] WITH NOCHECK ADD CONSTRAINT [FK_Compra_MtvoIngSal] FOREIGN KEY ([RucE], [Cd_MIS]) REFERENCES [dbo].[MtvoIngSal] ([RucE], [Cd_MIS])
GO
ALTER TABLE [dbo].[Compra] WITH NOCHECK ADD CONSTRAINT [FK_Compra_OrdCompra] FOREIGN KEY ([RucE], [Cd_OC]) REFERENCES [dbo].[OrdCompra] ([RucE], [Cd_OC])
GO
ALTER TABLE [dbo].[Compra] ADD CONSTRAINT [FK_Compra_Periodo] FOREIGN KEY ([RucE], [Ejer]) REFERENCES [dbo].[Periodo] ([RucE], [Ejer])
GO
ALTER TABLE [dbo].[Compra] WITH NOCHECK ADD CONSTRAINT [FK_Compra_Proveedor2] FOREIGN KEY ([RucE], [Cd_Prv]) REFERENCES [dbo].[Proveedor2] ([RucE], [Cd_Prv])
GO
ALTER TABLE [dbo].[Compra] WITH NOCHECK ADD CONSTRAINT [FK_Compra_TipDoc] FOREIGN KEY ([Cd_TD]) REFERENCES [dbo].[TipDoc] ([Cd_TD])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Compra', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CM00000001', 'SCHEMA', N'dbo', 'TABLE', N'Compra', 'COLUMN', N'Cd_Com'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Forma Pago/Cobro', 'SCHEMA', N'dbo', 'TABLE', N'Compra', 'COLUMN', N'Cd_FPC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Compra', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Compra', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Detraccion', 'SCHEMA', N'dbo', 'TABLE', N'Compra', 'COLUMN', N'DR_FecDet'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nro Comprobante No Domiciliado', 'SCHEMA', N'dbo', 'TABLE', N'Compra', 'COLUMN', N'DR_NCND'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nro Detraccion', 'SCHEMA', N'dbo', 'TABLE', N'Compra', 'COLUMN', N'DR_NroDet'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Importe Detraccion', 'SCHEMA', N'dbo', 'TABLE', N'Compra', 'COLUMN', N'ImpDetr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Nota Credito: DV (Devolucion) / DS (Descuento)', 'SCHEMA', N'dbo', 'TABLE', N'Compra', 'COLUMN', N'TipNC'
GO
