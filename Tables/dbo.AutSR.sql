CREATE TABLE [dbo].[AutSR]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SR] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecAut] [datetime] NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutSR] WITH NOCHECK ADD CONSTRAINT [FK_AutSR_SolicitudReq] FOREIGN KEY ([RucE], [Cd_SR]) REFERENCES [dbo].[SolicitudReq] ([RucE], [Cd_SR])
GO
EXEC sp_addextendedproperty N'MS_Description', N'SR00000001', 'SCHEMA', N'dbo', 'TABLE', N'AutSR', 'COLUMN', N'Cd_SR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'AutSR', 'COLUMN', N'NomUsu'
GO
