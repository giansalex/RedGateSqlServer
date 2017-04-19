CREATE TABLE [dbo].[SolicitudReqDet2]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SR] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cant] [numeric] (20, 10) NULL,
[Obs] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[FecCrea] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[IC_EstadoPS] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[IC_EstadoInv] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudReqDet2] ADD CONSTRAINT [PK_SolicitudReqDet2] PRIMARY KEY CLUSTERED  ([RucE], [Cd_SR], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudReqDet2] ADD CONSTRAINT [FK_SolicitudReqDet2_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[SolicitudReqDet2] ADD CONSTRAINT [FK_SolicitudReqDet2_Servicio2] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
ALTER TABLE [dbo].[SolicitudReqDet2] ADD CONSTRAINT [FK_SolicitudReqDet2_SolicitudReq2] FOREIGN KEY ([RucE], [Cd_SR]) REFERENCES [dbo].[SolicitudReq2] ([RucE], [Cd_SR])
GO
