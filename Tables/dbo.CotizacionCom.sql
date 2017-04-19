CREATE TABLE [dbo].[CotizacionCom]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SCo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroCSCo] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Env] [bit] NULL,
[FecEnv] [datetime] NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (7, 4) NULL,
[Cd_FPC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[IC_TipPrdPago] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[TiempoPago] [int] NULL,
[IC_TipPrdEnt] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[TiempoEnt] [int] NULL,
[IC_TipPrdGara] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[TiempoGara] [int] NULL,
[FecValida] [datetime] NULL,
[Obs] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CodSeg] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Resp] [bit] NULL,
[FecResp] [datetime] NULL,
[IB_Selec] [bit] NULL,
[FecSelec] [datetime] NULL,
[UsuCrea] [varchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecCrea] [datetime] NOT NULL,
[FecMdf] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CotizacionCom] ADD CONSTRAINT [PK_CotizacionCom] PRIMARY KEY CLUSTERED  ([RucE], [Cd_SCo], [Cd_Prv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CotizacionCom] ADD CONSTRAINT [FK_CotizacionCom_Proveedor2] FOREIGN KEY ([RucE], [Cd_Prv]) REFERENCES [dbo].[Proveedor2] ([RucE], [Cd_Prv])
GO
ALTER TABLE [dbo].[CotizacionCom] ADD CONSTRAINT [FK_CotizacionCom_SolicitudCom2] FOREIGN KEY ([RucE], [Cd_SCo]) REFERENCES [dbo].[SolicitudCom2] ([RucE], [Cd_SCo])
GO
