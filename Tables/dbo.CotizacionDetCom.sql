CREATE TABLE [dbo].[CotizacionDetCom]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SCo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cant] [numeric] (20, 10) NULL,
[ValorUni] [numeric] (20, 10) NULL,
[ValorNeto] [numeric] (20, 10) NULL,
[IC_TipPrdEnt] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[TiempoEnt] [int] NULL,
[Obs] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[FecCrea] [datetime] NOT NULL,
[FecMdf] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CotizacionDetCom] ADD CONSTRAINT [PK_CotizacionDetCom] PRIMARY KEY CLUSTERED  ([RucE], [Cd_SCo], [Cd_Prv], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CotizacionDetCom] ADD CONSTRAINT [FK_CotizacionDetCom_CotizacionCom] FOREIGN KEY ([RucE], [Cd_SCo], [Cd_Prv]) REFERENCES [dbo].[CotizacionCom] ([RucE], [Cd_SCo], [Cd_Prv])
GO
