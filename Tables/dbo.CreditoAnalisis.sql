CREATE TABLE [dbo].[CreditoAnalisis]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_ACrd] [int] NOT NULL,
[FecMov] [smalldatetime] NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[TipoVivienda] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[EstCivil] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[CantFam] [int] NULL,
[CantHijos] [int] NULL,
[Sexo] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Ren01] [decimal] (13, 2) NULL,
[Ren02] [decimal] (13, 2) NULL,
[Ren03] [decimal] (13, 2) NULL,
[Ren04] [decimal] (13, 2) NULL,
[Ren05] [decimal] (13, 2) NULL,
[OtrosIng] [decimal] (13, 2) NULL,
[TotalIng] [decimal] (13, 2) NULL,
[CanastaFam] [decimal] (13, 2) NULL,
[Vivienda] [decimal] (13, 2) NULL,
[Colegio] [decimal] (13, 2) NULL,
[PrestamoBan] [decimal] (13, 2) NULL,
[CreditoBan] [decimal] (13, 2) NULL,
[OtrosEgr1] [decimal] (13, 2) NULL,
[OtrosEgr2] [decimal] (13, 2) NULL,
[TotalEgr] [decimal] (13, 2) NULL,
[SaldoDisp] [decimal] (13, 2) NULL,
[PorcDisp] [decimal] (5, 2) NULL,
[ImpDisp] [decimal] (13, 2) NULL,
[ValorCrd] [decimal] (13, 2) NULL,
[TasaAnu] [decimal] (5, 2) NULL,
[ValorTasa] [decimal] (13, 2) NULL,
[TotalCrd] [decimal] (13, 2) NULL,
[NroCuotas] [int] NULL,
[CuotaMen] [decimal] (13, 2) NULL,
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
[CA20] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CreditoAnalisis] ADD CONSTRAINT [PK_CreditoAnalisis] PRIMARY KEY CLUSTERED  ([RucE], [Cd_ACrd]) ON [PRIMARY]
GO