CREATE TABLE [dbo].[SolicitudReq]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SR] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroSR] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[FecEmi] [smalldatetime] NOT NULL,
[FecEntR] [smalldatetime] NULL,
[Asunto] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[ElaboradoPor] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[AutorizadoPor] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Id_EstSR] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[TipAut] [int] NULL,
[IB_Aut] [bit] NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Id_EstSRS] [char] (2) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudReq] ADD CONSTRAINT [PK_SolicitudReg] PRIMARY KEY CLUSTERED  ([RucE], [Cd_SR]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudReq] ADD CONSTRAINT [IX_SolicitudReq__RucE_NroSR] UNIQUE NONCLUSTERED  ([RucE], [NroSR]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudReq] WITH NOCHECK ADD CONSTRAINT [FK_SolicitudReq_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[SolicitudReq] WITH NOCHECK ADD CONSTRAINT [FK_SolicitudReq_EstadoSR] FOREIGN KEY ([Id_EstSR]) REFERENCES [dbo].[EstadoSR] ([Id_EstSR])
GO
ALTER TABLE [dbo].[SolicitudReq] ADD CONSTRAINT [FK_SolicitudReq_EstadoSR_Srv] FOREIGN KEY ([Id_EstSRS]) REFERENCES [dbo].[EstadoSR_Srv] ([Id_EstSRS])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReq', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReq', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SR00000001', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReq', 'COLUMN', N'Cd_SR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReq', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fec. de Entrega Requerida', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReq', 'COLUMN', N'FecEntR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Autorizado', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReq', 'COLUMN', N'IB_Aut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Solicitud Compra', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReq', 'COLUMN', N'Id_EstSR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Solicitud Compra para Servicios', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReq', 'COLUMN', N'Id_EstSRS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0000001', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReq', 'COLUMN', N'NroSR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Autorizable', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudReq', 'COLUMN', N'TipAut'
GO
