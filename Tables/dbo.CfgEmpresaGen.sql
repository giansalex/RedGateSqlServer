CREATE TABLE [dbo].[CfgEmpresaGen]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[HabilitaReteciones] [bit] NULL,
[PriorizaConcSunat] [bit] NULL,
[HabilitaListaPrecio] [bit] NULL,
[AmarraCltAVdr] [bit] NULL,
[IB_MdfVta] [bit] NULL,
[PtoVtaHabilitaSaldos] [bit] NULL,
[PtoVta_Cd_MIS_Saldos] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TDXDef_Clt] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TDXDef_Vdr] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgEmpresaGen] ADD CONSTRAINT [PK_CfgEmpresaGen] PRIMARY KEY CLUSTERED  ([RucE]) ON [PRIMARY]
GO
