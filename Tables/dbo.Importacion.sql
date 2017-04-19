CREATE TABLE [dbo].[Importacion]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_IP] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroImp] [varchar] (25) COLLATE Modern_Spanish_CI_AS NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMov] [smalldatetime] NOT NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Asunto] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[EXWT] [numeric] (13, 4) NULL,
[EXWT_ME] [numeric] (13, 4) NULL,
[ComT] [numeric] (13, 4) NULL,
[ComT_ME] [numeric] (13, 4) NULL,
[OtroET] [numeric] (13, 4) NULL,
[OtroET_ME] [numeric] (13, 4) NULL,
[FOBT] [numeric] (13, 4) NULL,
[FOBT_ME] [numeric] (13, 4) NULL,
[FleteT] [numeric] (13, 4) NULL,
[FleteT_ME] [numeric] (13, 4) NULL,
[SegT] [numeric] (13, 4) NULL,
[SegT_ME] [numeric] (13, 4) NULL,
[OtroFT] [numeric] (13, 4) NULL,
[OtroFT_ME] [numeric] (13, 4) NULL,
[CIFT] [numeric] (13, 4) NULL,
[CIFT_ME] [numeric] (13, 4) NULL,
[AdvT] [numeric] (13, 4) NULL,
[AdvT_ME] [numeric] (13, 4) NULL,
[OtroCT] [numeric] (13, 4) NULL,
[OtroCT_ME] [numeric] (13, 4) NULL,
[Total] [numeric] (13, 4) NULL,
[Total_ME] [numeric] (13, 4) NULL,
[RatioT] [numeric] (13, 4) NULL,
[RatioT_ME] [numeric] (13, 4) NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
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
[CA10] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Importacion] ADD CONSTRAINT [PK_Importacion] PRIMARY KEY CLUSTERED  ([RucE], [Cd_IP]) ON [PRIMARY]
GO
