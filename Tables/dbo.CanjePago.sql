CREATE TABLE [dbo].[CanjePago]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cnj] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Prdo] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[FecMov] [smalldatetime] NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_MIS] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[TipCam] [numeric] (13, 3) NULL,
[CantLtr] [int] NULL,
[OtrosImp] [numeric] (13, 2) NULL,
[Total] [numeric] (13, 2) NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [varchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NULL,
[FecMdf] [datetime] NULL,
[UsuReg] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[UsuMdf] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
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
[IB_Anulado] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CanjePago] ADD CONSTRAINT [PK_CanjePago] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Cnj]) ON [PRIMARY]
GO
