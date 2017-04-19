CREATE TABLE [dbo].[CfgGeneral]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_MovVtaCtbLin] [bit] NULL,
[IB_MovComCtbLin] [bit] NULL,
[IB_MovInvCtbLin] [bit] NULL,
[IB_ElmCtbVtaLin] [bit] NULL,
[IB_ElmCtbComLin] [bit] NULL,
[IB_ElmCtbInvLin] [bit] NULL,
[NomC] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[NomSC] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[NomSSC] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[IB_AgRet] [bit] NULL,
[MtoRet] [numeric] (13, 2) NULL,
[NivCC] [int] NULL,
[IB_MdfVou] [bit] NULL,
[IB_ACtt] [bit] NULL,
[Redondeo] [int] NULL,
[IB_EjerAnt] [bit] NULL,
[IB_AlertCD] [bit] NULL,
[IB_KardexAlm] [bit] NULL,
[IB_KardexUM] [bit] NULL,
[Cd_TDIClt] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TDIPrv] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TDIVdr] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TDITra] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[IB_AgPercep] [bit] NULL,
[IB_BuenContrib] [bit] NULL,
[MtoMinimoParaRetencion] [numeric] (22, 7) NULL,
[PorcentajeParaRetencion] [numeric] (6, 3) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgGeneral] ADD CONSTRAINT [PK_CfgGeneral] PRIMARY KEY CLUSTERED  ([RucE]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgGeneral] ADD CONSTRAINT [FK_CfgGeneral_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Es Agente Retencion', 'SCHEMA', N'dbo', 'TABLE', N'CfgGeneral', 'COLUMN', N'IB_AgRet'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Alerta para el Control de Documentos', 'SCHEMA', N'dbo', 'TABLE', N'CfgGeneral', 'COLUMN', N'IB_AlertCD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ver ejercicio anterior en los exploradores', 'SCHEMA', N'dbo', 'TABLE', N'CfgGeneral', 'COLUMN', N'IB_EjerAnt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto minimo para retencion', 'SCHEMA', N'dbo', 'TABLE', N'CfgGeneral', 'COLUMN', N'MtoRet'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nivel de CC', 'SCHEMA', N'dbo', 'TABLE', N'CfgGeneral', 'COLUMN', N'NivCC'
GO
