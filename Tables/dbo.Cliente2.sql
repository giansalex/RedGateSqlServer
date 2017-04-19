CREATE TABLE [dbo].[Cliente2]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TDI] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[NDoc] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[RSocial] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[ApPat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[ApMat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Nom] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Pais] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[CodPost] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Ubigeo] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Direc] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Telf1] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Telf2] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Fax] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Correo] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[PWeb] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[CtaCtb] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[DiasCbr] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[PerCbr] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[CtaCte] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CGC] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL,
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
[Cd_Aux] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TClt] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[NComercial] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[IB_AgRet] [bit] NULL,
[IB_AgPercep] [bit] NULL,
[IB_BuenContrib] [bit] NULL,
[Cd_Vdr] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[SaldoAFavor] [decimal] (18, 7) NULL,
[Snt_TipCntrb] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Snt_FecInscrip] [smalldatetime] NULL,
[Snt_FecIniAct] [smalldatetime] NULL,
[Snt_FecBaja] [smalldatetime] NULL,
[Snt_EstCntrb] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Snt_CondCntrb] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Snt_SisEmiComp] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Snt_SisContab] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Snt_LstActsEcono] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Snt_LstCompsPago] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[Snt_ActComExt] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Snt_LstSisEmiElec] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[Snt_FecEmiElec] [smalldatetime] NULL,
[Snt_LstCompsElec] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[Snt_FecInsPLE] [smalldatetime] NULL,
[Snt_NroTrab] [int] NULL,
[Snt_LstRprsLegs] [varchar] (2000) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cliente2] ADD CONSTRAINT [PK_Cliente2] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Clt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cliente2] ADD CONSTRAINT [IX_Cliente2_Ruc_TD_Nro] UNIQUE NONCLUSTERED  ([RucE], [Cd_TDI], [NDoc]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cliente2] ADD CONSTRAINT [FK_Cliente2_ComisionGrupCte] FOREIGN KEY ([RucE], [Cd_CGC]) REFERENCES [dbo].[ComisionGrupCte] ([RucE], [Cd_CGC])
GO
ALTER TABLE [dbo].[Cliente2] ADD CONSTRAINT [FK_Cliente2_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[Cliente2] ADD CONSTRAINT [FK_Cliente2_TipClt] FOREIGN KEY ([RucE], [Cd_TClt]) REFERENCES [dbo].[TipClt] ([RucE], [Cd_TClt])
GO
ALTER TABLE [dbo].[Cliente2] ADD CONSTRAINT [FK_Vendedor2_Cliente2] FOREIGN KEY ([RucE], [Cd_Vdr]) REFERENCES [dbo].[Vendedor2] ([RucE], [Cd_Vdr])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo para homologar con Cliente 1', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Cd_Aux'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Comision Grupo Cliente', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Cd_CGC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Tipo Cliente', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Cd_TClt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cuenta Corriente', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'CtaCte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dias de Cobro', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'DiasCbr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Direccion Principal de la empresa', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Direc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Persona Cobro', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'PerCbr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Actividad de Comercio Exterior', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_ActComExt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Condicion Contribuyente', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_CondCntrb'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Contribuyente', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_EstCntrb'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Baja Contribuyente', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_FecBaja'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Emisor Electronico desde', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_FecEmiElec'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Inicio Actividades', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_FecIniAct'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Inscripción', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_FecInscrip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha afiliacion a PLE (Programa Libros Electronicos)', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_FecInsPLE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lista Actividades Economicas', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_LstActsEcono'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lista Comprobantes Electronicos', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_LstCompsElec'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lista Comprobantes de Pago', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_LstCompsPago'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lista Representantes Legales', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_LstRprsLegs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lista Sistema de Emision Electronica', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_LstSisEmiElec'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de trabajadores', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_NroTrab'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sistema de Contabilidad', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_SisContab'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sistema de Emision de Comprobante', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_SisEmiComp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Contribuyente', 'SCHEMA', N'dbo', 'TABLE', N'Cliente2', 'COLUMN', N'Snt_TipCntrb'
GO
