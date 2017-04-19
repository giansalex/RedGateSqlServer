CREATE TABLE [dbo].[Voucher]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vou] [int] NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Prdo] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Fte] [varchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMov] [smalldatetime] NOT NULL,
[FecCbr] [smalldatetime] NULL,
[NroCta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Aux] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[NroSre] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[FecED] [smalldatetime] NULL,
[FecVD] [smalldatetime] NULL,
[Glosa] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[MtoOr] [numeric] (13, 2) NOT NULL CONSTRAINT [DF_Vocher_MtoOr] DEFAULT ((0)),
[MtoD] [numeric] (13, 2) NOT NULL,
[MtoH] [numeric] (13, 2) NOT NULL,
[MtoD_ME] [numeric] (13, 2) NULL,
[MtoH_ME] [numeric] (13, 2) NULL,
[Cd_MdOr] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MdRg] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CamMda] [numeric] (6, 3) NOT NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TG] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IC_CtrMd] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL,
[IC_TipAfec] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL,
[TipOper] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[NroChke] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[Grdo] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Cndo] [bit] NULL,
[IB_Conc] [bit] NULL,
[IB_EsProv] [bit] NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Anulado] [bit] NOT NULL,
[DR_CdVou] [int] NULL,
[DR_FecED] [smalldatetime] NULL,
[DR_CdTD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[DR_NSre] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[DR_NDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[IC_Gen] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL,
[FecConc] [smalldatetime] NULL,
[IB_EsDes] [bit] NULL,
[DR_NCND] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[DR_NroDet] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[DR_FecDet] [smalldatetime] NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Imdo] [bit] NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TMP] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
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
[CodT] [char] (4) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Voucher] ADD CONSTRAINT [PK_Voucher] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Vou]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'Voucher', 'COLUMN', N'Cd_Fte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Detraccion', 'SCHEMA', N'dbo', 'TABLE', N'Voucher', 'COLUMN', N'DR_FecDet'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nro Comprobante No Domiciliado', 'SCHEMA', N'dbo', 'TABLE', N'Voucher', 'COLUMN', N'DR_NCND'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nro Detraccion', 'SCHEMA', N'dbo', 'TABLE', N'Voucher', 'COLUMN', N'DR_NroDet'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Conciliacion', 'SCHEMA', N'dbo', 'TABLE', N'Voucher', 'COLUMN', N'FecConc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Es Destino', 'SCHEMA', N'dbo', 'TABLE', N'Voucher', 'COLUMN', N'IB_EsDes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador es Importado', 'SCHEMA', N'dbo', 'TABLE', N'Voucher', 'COLUMN', N'IB_Imdo'
GO
