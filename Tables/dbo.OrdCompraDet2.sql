CREATE TABLE [dbo].[OrdCompraDet2]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OC] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Obs] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[ValorUni] [numeric] (20, 10) NULL,
[DsctoUniP] [numeric] (5, 2) NULL,
[DsctoUniI] [numeric] (20, 10) NULL,
[BimUni] [numeric] (20, 10) NULL,
[IgvUni] [numeric] (20, 10) NULL,
[PrecioUni] [numeric] (20, 10) NULL,
[Cant] [numeric] (20, 10) NULL,
[ValorTotal] [numeric] (20, 10) NULL,
[DsctoP] [numeric] (5, 2) NULL,
[DsctoI] [numeric] (20, 10) NULL,
[Bim] [numeric] (20, 10) NULL,
[Igv] [numeric] (20, 10) NULL,
[Total] [numeric] (20, 10) NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[IC_EstadoPS] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[IC_EstadoInv] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecCrea] [datetime] NOT NULL,
[FecMdf] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdCompraDet2] ADD CONSTRAINT [PK_OrdCompraDet2] PRIMARY KEY CLUSTERED  ([RucE], [Cd_OC], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdCompraDet2] ADD CONSTRAINT [FK_OrdCompraDet2_OrdCompra2] FOREIGN KEY ([RucE], [Cd_OC]) REFERENCES [dbo].[OrdCompra2] ([RucE], [Cd_OC])
GO
ALTER TABLE [dbo].[OrdCompraDet2] ADD CONSTRAINT [FK_OrdCompraDet2_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[OrdCompraDet2] ADD CONSTRAINT [FK_OrdCompraDet2_Servicio2] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
