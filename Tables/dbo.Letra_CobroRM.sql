CREATE TABLE [dbo].[Letra_CobroRM]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cnj] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Ltr] [int] NOT NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[NroRenv] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[NroLtr] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[RefGdor] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[LugGdor] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[FecGiro] [smalldatetime] NULL,
[FecVenc] [smalldatetime] NULL,
[Plazo] [int] NULL,
[Imp] [numeric] (13, 2) NULL,
[Dsct] [numeric] (13, 2) NULL,
[Total] [numeric] (13, 2) NULL,
[FecReg] [datetime] NULL,
[Cd_Est] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
