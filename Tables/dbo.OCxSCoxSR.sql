CREATE TABLE [dbo].[OCxSCoxSR]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_FluCom] [int] NOT NULL,
[Cd_OC] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SCo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SR] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Item] [int] NOT NULL,
[Cant] [numeric] (20, 10) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OCxSCoxSR] ADD CONSTRAINT [PK_OCxSCoxSR] PRIMARY KEY CLUSTERED  ([RucE], [ID_FluCom]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OCxSCoxSR] ADD CONSTRAINT [FK_OCxSCo_OrdCompra2] FOREIGN KEY ([RucE], [Cd_OC]) REFERENCES [dbo].[OrdCompra2] ([RucE], [Cd_OC])
GO
ALTER TABLE [dbo].[OCxSCoxSR] ADD CONSTRAINT [FK_OCxSCo_SolicitudCom2] FOREIGN KEY ([RucE], [Cd_SCo]) REFERENCES [dbo].[SolicitudCom2] ([RucE], [Cd_SCo])
GO
ALTER TABLE [dbo].[OCxSCoxSR] ADD CONSTRAINT [FK_OCxSCoxSR_SolicitudReq2] FOREIGN KEY ([RucE], [Cd_SR]) REFERENCES [dbo].[SolicitudReq2] ([RucE], [Cd_SR])
GO
