CREATE TABLE [dbo].[FabEtaIns]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Fab] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Eta] [int] NOT NULL,
[ID_EtaIns] [int] NOT NULL,
[Cd_Flujo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Prc] [int] NOT NULL,
[ID_Ins] [int] NULL,
[Fec] [date] NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[Cant] [numeric] (15, 7) NULL,
[Costo] [numeric] (15, 7) NULL,
[Costo_ME] [numeric] (15, 7) NULL,
[CantInsTotal] [decimal] (13, 7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabEtaIns] ADD CONSTRAINT [PK_FabEtaIns] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Fab], [ID_Eta], [ID_EtaIns]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabEtaIns] ADD CONSTRAINT [FK_FabEtaIns_FabEtapa] FOREIGN KEY ([RucE], [Cd_Fab], [ID_Eta]) REFERENCES [dbo].[FabEtapa] ([RucE], [Cd_Fab], [ID_Eta])
GO
ALTER TABLE [dbo].[FabEtaIns] ADD CONSTRAINT [FK_FabEtaIns_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabEtaIns', 'COLUMN', N'Costo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabEtaIns', 'COLUMN', N'Costo_ME'
GO
