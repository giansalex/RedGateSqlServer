CREATE TABLE [dbo].[CotizacionProdDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cot] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_CtD] [int] NOT NULL,
[Item] [int] NOT NULL,
[Cpto] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Valor] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CotizacionProdDet] ADD CONSTRAINT [PK_CotizacionProdDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Cot], [ID_CtD], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CotizacionProdDet] WITH NOCHECK ADD CONSTRAINT [FK_CotizacionProdDet_CotizacionDet] FOREIGN KEY ([RucE], [Cd_Cot], [ID_CtD]) REFERENCES [dbo].[CotizacionDet] ([RucE], [Cd_Cot], [ID_CtD])
GO
