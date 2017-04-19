CREATE TABLE [dbo].[Proveedor2]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TDI] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NDoc] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RSocial] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[ApPat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[ApMat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Nom] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Pais] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[CodPost] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Ubigeo] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Direc] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Telf1] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Telf2] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Fax] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Correo] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[PWeb] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[CtaCtb] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[IB_SjDet] [bit] NULL,
[Cd_TPrv] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Grupo] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[DiasCobro] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[LimiteCredito] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CtasCrtes] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[PerCobro] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[NComercial] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[IB_AgRet] [bit] NULL,
[IB_AgPercep] [bit] NULL,
[IB_BuenContrib] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Proveedor2] ADD CONSTRAINT [PK_Proveedor2] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Prv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Proveedor2] ADD CONSTRAINT [IX_Proveedor2_Ruc_TD_NDoc] UNIQUE NONCLUSTERED  ([RucE], [Cd_TDI], [NDoc]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Proveedor2] WITH NOCHECK ADD CONSTRAINT [FK_Proveedor2_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[Proveedor2] WITH NOCHECK ADD CONSTRAINT [FK_Proveedor2_Pais] FOREIGN KEY ([Cd_Pais]) REFERENCES [dbo].[Pais] ([Cd_Pais])
GO
ALTER TABLE [dbo].[Proveedor2] WITH NOCHECK ADD CONSTRAINT [FK_Proveedor2_TipDocIdn] FOREIGN KEY ([Cd_TDI]) REFERENCES [dbo].[TipDocIdn] ([Cd_TDI])
GO
ALTER TABLE [dbo].[Proveedor2] ADD CONSTRAINT [FK_Proveedor2_TipProv] FOREIGN KEY ([RucE], [Cd_TPrv]) REFERENCES [dbo].[TipProv] ([RucE], [Cd_TPrv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Tipo Proveedor', 'SCHEMA', N'dbo', 'TABLE', N'Proveedor2', 'COLUMN', N'Cd_TPrv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Sujeto a detraccion', 'SCHEMA', N'dbo', 'TABLE', N'Proveedor2', 'COLUMN', N'IB_SjDet'
GO
