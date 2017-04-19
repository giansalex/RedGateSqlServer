CREATE TABLE [dbo].[PlanCtas]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [varchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroCta] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomCta] [varchar] (200) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nivel] [int] NULL,
[IB_Aux] [bit] NULL,
[IB_CC] [bit] NULL,
[IB_DifC] [bit] NULL,
[IC_ACV] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL,
[IC_ASM] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL,
[IB_GCB] [bit] NULL,
[IB_Psp] [bit] NULL,
[IB_CtaD] [bit] NULL,
[IB_MdVta] [bit] NULL,
[IB_MdCom] [bit] NULL,
[IB_MdCtb] [bit] NULL,
[IB_MdTsr] [bit] NULL,
[IB_MdPrs] [bit] NULL,
[IB_MdInv] [bit] NULL,
[Cd_Blc] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_EGPN] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_EGPF] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[IB_CtasXCbr] [bit] NULL,
[IB_CtasXPag] [bit] NULL,
[Estado] [bit] NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[IC_IEF] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL,
[IC_IEN] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL,
[NroCtaH1] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[NomCtaH1] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[NroCtaH2] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[NomCtaH2] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[IB_PFC] [bit] NULL,
[IB_NDoc] [bit] NULL,
[IB_Prod] [bit] NULL,
[IB_Imp] [bit] NULL,
[IB_Dtr] [bit] NULL,
[IB_IGV] [bit] NULL,
[REF01] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[REF02] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[REF03] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[REF04] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[REF05] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[REF06] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[REF07] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[REF08] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[REF09] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[REF10] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IB_MCC] [bit] NULL,
[IB_MCE] [bit] NULL,
[IB_Perc] [bit] NULL,
[IB_Ret] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PlanCtas] ADD CONSTRAINT [PK_PlanCtas] PRIMARY KEY CLUSTERED  ([RucE], [Ejer], [NroCta]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Nro Documento', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'IB_NDoc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Presupuesto Flujo Caja', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'IB_PFC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Ingreso_Egreso Funcion', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'IC_IEF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Ingreso_Egreso Naturaleza', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'IC_IEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre Cta Homologada 1', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'NomCtaH1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre Cta Homologada 2', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'NomCtaH2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nro Cta Homologada 1', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'NroCtaH1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nro Cta Homologada 2', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'NroCtaH2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reporte adicional para Estado Financiero - REF01', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'REF01'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reporte adicional para Estado Financiero - REF02', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'REF02'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reporte adicional para Estado Financiero - REF03', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'REF03'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reporte adicional para Estado Financiero - REF04', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'REF04'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reporte adicional para Estado Financiero - REF05', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'REF05'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reporte adicional para Estado Financiero - REF06', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'REF06'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reporte adicional para Estado Financiero - REF07', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'REF07'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reporte adicional para Estado Financiero - REF08', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'REF08'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reporte adicional para Estado Financiero - REF09', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'REF09'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reporte adicional para Estado Financiero - REF10', 'SCHEMA', N'dbo', 'TABLE', N'PlanCtas', 'COLUMN', N'REF10'
GO
