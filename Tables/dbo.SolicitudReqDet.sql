CREATE TABLE [dbo].[SolicitudReqDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SR] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SRV] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Cant] [numeric] (13, 3) NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IB_AtSrv] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudReqDet] ADD CONSTRAINT [PK_SolicitudRegDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_SR], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudReqDet] WITH NOCHECK ADD CONSTRAINT [FK_SolicitudReqDet_SolicitudReq] FOREIGN KEY ([RucE], [Cd_SR]) REFERENCES [dbo].[SolicitudReq] ([RucE], [Cd_SR]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'SR00000001', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReqDet', 'COLUMN', N'Cd_SR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRC0001', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReqDet', 'COLUMN', N'Cd_SRV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrip para prod. no propios', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReqDet', 'COLUMN', N'Descrip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para Servicios Atendidos', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReqDet', 'COLUMN', N'IB_AtSrv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReqDet', 'COLUMN', N'RucE'
GO
