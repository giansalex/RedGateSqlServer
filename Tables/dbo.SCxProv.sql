CREATE TABLE [dbo].[SCxProv]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SCoEnv] [int] NOT NULL,
[Cd_SCo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Env] [bit] NULL,
[FecEnv] [datetime] NULL,
[IB_Impr] [bit] NULL,
[FecImpr] [datetime] NULL,
[Prv_FecEnt] [smalldatetime] NULL,
[Prv_Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Acp] [bit] NULL,
[Indicador] [char] (8) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Resp] [bit] NULL,
[Id_EstSCResp] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[FecResp] [datetime] NULL,
[FecEnt] [datetime] NULL,
[Cd_FPC] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[DiasPago] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SCxProv] ADD CONSTRAINT [PK_SCxProv] PRIMARY KEY CLUSTERED  ([RucE], [Cd_SCoEnv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SCxProv] ADD CONSTRAINT [FK_SCxProv_Estado_SCResp] FOREIGN KEY ([Id_EstSCResp]) REFERENCES [dbo].[Estado_SCResp] ([Id_EstSCResp])
GO
ALTER TABLE [dbo].[SCxProv] WITH NOCHECK ADD CONSTRAINT [FK_SCxProv_Proveedor2] FOREIGN KEY ([RucE], [Cd_Prv]) REFERENCES [dbo].[Proveedor2] ([RucE], [Cd_Prv])
GO
ALTER TABLE [dbo].[SCxProv] WITH NOCHECK ADD CONSTRAINT [FK_SCxProv_SolicitudCom] FOREIGN KEY ([RucE], [Cd_SCo]) REFERENCES [dbo].[SolicitudCom] ([RucE], [Cd_SCo]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'SC00000001', 'SCHEMA', N'dbo', 'TABLE', N'SCxProv', 'COLUMN', N'Cd_SCo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aceptado-> Ya no se debe usar', 'SCHEMA', N'dbo', 'TABLE', N'SCxProv', 'COLUMN', N'IB_Acp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador booleano para respuesta del proveedor', 'SCHEMA', N'dbo', 'TABLE', N'SCxProv', 'COLUMN', N'IB_Resp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador que indica estado de respuesta del proveedor', 'SCHEMA', N'dbo', 'TABLE', N'SCxProv', 'COLUMN', N'Id_EstSCResp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigos unicos por cada proveedor para la Web', 'SCHEMA', N'dbo', 'TABLE', N'SCxProv', 'COLUMN', N'Indicador'
GO
