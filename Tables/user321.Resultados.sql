CREATE TABLE [user321].[Resultados]
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
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Sr] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Num] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NULL,
[FecED] [smalldatetime] NULL,
[FecVD] [smalldatetime] NULL,
[Cd_Cte] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vdr] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[INF] [decimal] (13, 2) NULL,
[EXO] [decimal] (13, 2) NULL,
[BIM] [decimal] (13, 2) NULL,
[IGV] [decimal] (13, 2) NOT NULL,
[Total] [decimal] (13, 2) NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CamMda] [decimal] (6, 3) NOT NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NOT NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
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
[NroOP] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[TotDsctoP] [decimal] (5, 2) NULL,
[TotDsctoI] [decimal] (13, 2) NULL,
[ValorNeto] [decimal] (13, 2) NULL,
[DsctoFnzP] [decimal] (5, 2) NULL,
[DsctoFnzI] [decimal] (13, 2) NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[NroSre] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
