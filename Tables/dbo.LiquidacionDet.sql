CREATE TABLE [dbo].[LiquidacionDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Liq] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL CONSTRAINT [DF_CajaChicaDet_Cd_CajaChica] DEFAULT (N'Codigo Compra'),
[Item] [int] NOT NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[FecMov] [smalldatetime] NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[NroSre] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[FecED] [smalldatetime] NULL,
[FecVD] [smalldatetime] NULL,
[Itm_BC] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[ValorU] [numeric] (15, 7) NULL,
[DsctoP] [numeric] (5, 2) NULL,
[DsctoI] [numeric] (15, 7) NULL,
[BIMU] [numeric] (15, 7) NULL,
[IGVU] [numeric] (15, 7) NULL,
[TotalU] [numeric] (15, 7) NULL,
[Cantidad] [decimal] (13, 3) NULL,
[BIM] [numeric] (15, 7) NULL,
[IGV] [numeric] (15, 7) NULL,
[Total] [numeric] (15, 7) NULL,
[IB_Cancelado] [bit] NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_MIS] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (6, 3) NULL,
[FecReg] [datetime] NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
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
[CA15] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LiquidacionDet] ADD CONSTRAINT [PK_CajaChicaDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Liq], [Item]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'LiquidacionDet', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CM00000001', 'SCHEMA', N'dbo', 'TABLE', N'LiquidacionDet', 'COLUMN', N'Cd_Liq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'LiquidacionDet', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRV0001/SRC0001 (Segun IC_TipServ)', 'SCHEMA', N'dbo', 'TABLE', N'LiquidacionDet', 'COLUMN', N'Cd_Srv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'LiquidacionDet', 'COLUMN', N'Cd_SS'
GO
