CREATE TABLE [dbo].[SolicitudCom]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SCo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroSC] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[FecEmi] [smalldatetime] NOT NULL,
[FecEntR] [smalldatetime] NULL,
[Cd_FPC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Asunto] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[ElaboradoPor] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[AutorizadoPor] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SR] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Id_EstSC] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
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
[Id_EstSCS] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Impreso] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudCom] ADD CONSTRAINT [PK_SolicitudCom] PRIMARY KEY CLUSTERED  ([RucE], [Cd_SCo]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudCom] ADD CONSTRAINT [IX_SolicitudCom__RucE_NroSC] UNIQUE NONCLUSTERED  ([RucE], [NroSC]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SolicitudCom] WITH NOCHECK ADD CONSTRAINT [FK_SolicitudCom_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[SolicitudCom] WITH NOCHECK ADD CONSTRAINT [FK_SolicitudCom_EstadoSC] FOREIGN KEY ([Id_EstSC]) REFERENCES [dbo].[EstadoSC] ([Id_EstSC])
GO
ALTER TABLE [dbo].[SolicitudCom] ADD CONSTRAINT [FK_SolicitudCom_EstadoSC_Srv] FOREIGN KEY ([Id_EstSCS]) REFERENCES [dbo].[EstadoSC_Srv] ([Id_EstSCS])
GO
ALTER TABLE [dbo].[SolicitudCom] WITH NOCHECK ADD CONSTRAINT [FK_SolicitudCom_SolicitudReq] FOREIGN KEY ([RucE], [Cd_SR]) REFERENCES [dbo].[SolicitudReq] ([RucE], [Cd_SR])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SC00000001', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'Cd_SCo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SR00000001', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'Cd_SR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fec. de Entrega Requerida', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'FecEntR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Autorizado', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'IB_Aut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Solicitud Compra', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'Id_EstSC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Solicitud Compra para Servicios', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'Id_EstSCS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0000001', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'NroSC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Autorizable', 'SCHEMA', N'dbo', 'TABLE', N'SolicitudCom', 'COLUMN', N'TipAut'
GO
