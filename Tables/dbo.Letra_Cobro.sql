CREATE TABLE [dbo].[Letra_Cobro]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Ltr] [int] NOT NULL,
[Cd_Cnj] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
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
[FecMdf] [datetime] NULL,
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
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Letra_Cobro] ADD CONSTRAINT [PK_Letra_Cobro_1] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Ltr]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Letra_Cobro] ADD CONSTRAINT [FK_Letra_Cobro_Canje] FOREIGN KEY ([RucE], [Cd_Cnj]) REFERENCES [dbo].[Canje] ([RucE], [Cd_Cnj])
GO
