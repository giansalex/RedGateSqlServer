CREATE TABLE [dbo].[SCoxSR]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SCo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SR] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cant] [numeric] (20, 10) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SCoxSR] ADD CONSTRAINT [PK_SCoxSR] PRIMARY KEY CLUSTERED  ([RucE], [Cd_SCo], [Cd_SR], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SCoxSR] ADD CONSTRAINT [FK_SCoxSR_SolicitudCom2] FOREIGN KEY ([RucE], [Cd_SCo]) REFERENCES [dbo].[SolicitudCom2] ([RucE], [Cd_SCo])
GO
ALTER TABLE [dbo].[SCoxSR] ADD CONSTRAINT [FK_SCoxSR_SolicitudReq2] FOREIGN KEY ([RucE], [Cd_SR]) REFERENCES [dbo].[SolicitudReq2] ([RucE], [Cd_SR])
GO
