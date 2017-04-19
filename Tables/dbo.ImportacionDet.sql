CREATE TABLE [dbo].[ImportacionDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_IP] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Cd_Com] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ItemCP] [int] NOT NULL,
[Cant] [numeric] (13, 3) NULL,
[PesoKg] [numeric] (18, 3) NULL,
[Volumen] [numeric] (18, 3) NULL,
[EXW] [numeric] (13, 4) NULL,
[EXW_ME] [numeric] (13, 4) NULL,
[Com] [numeric] (13, 4) NULL,
[Com_ME] [numeric] (13, 4) NULL,
[OtroE] [numeric] (13, 4) NULL,
[OtroE_ME] [numeric] (13, 4) NULL,
[FOB] [numeric] (13, 4) NULL,
[FOB_ME] [numeric] (13, 4) NULL,
[Flete] [numeric] (13, 4) NULL,
[Flete_ME] [numeric] (13, 4) NULL,
[Seg] [numeric] (13, 4) NULL,
[Seg_ME] [numeric] (13, 4) NULL,
[OtroF] [numeric] (13, 4) NULL,
[OtroF_ME] [numeric] (13, 4) NULL,
[CIF] [numeric] (13, 4) NULL,
[CIF_ME] [numeric] (13, 4) NULL,
[Adv] [numeric] (13, 4) NULL,
[Adv_ME] [numeric] (13, 4) NULL,
[OtroC] [numeric] (13, 4) NULL,
[OtroC_ME] [numeric] (13, 4) NULL,
[Total] [numeric] (13, 4) NULL,
[Total_ME] [numeric] (13, 4) NULL,
[CU] [numeric] (13, 4) NULL,
[CU_ME] [numeric] (13, 4) NULL,
[Ratio] [numeric] (13, 4) NULL,
[Ratio_ME] [numeric] (13, 4) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImportacionDet] ADD CONSTRAINT [PK_ImportacionDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_IP], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImportacionDet] ADD CONSTRAINT [FK_ImportacionDet_Importacion] FOREIGN KEY ([RucE], [Cd_IP]) REFERENCES [dbo].[Importacion] ([RucE], [Cd_IP])
GO
ALTER TABLE [dbo].[ImportacionDet] ADD CONSTRAINT [FK_ImportacionDet_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[ImportacionDet] ADD CONSTRAINT [FK_ImportacionDet_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
