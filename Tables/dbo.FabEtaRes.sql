CREATE TABLE [dbo].[FabEtaRes]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Fab] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Eta] [int] NOT NULL,
[ID_EtaRes] [int] NOT NULL,
[Cd_Flujo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Prc] [int] NOT NULL,
[ID_Res] [int] NOT NULL,
[Fec] [date] NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[Cant] [numeric] (15, 7) NULL,
[Costo] [numeric] (15, 7) NULL,
[Costo_ME] [numeric] (15, 7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabEtaRes] ADD CONSTRAINT [PK_FabEtaRes] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Fab], [ID_Eta], [ID_EtaRes]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabEtaRes] ADD CONSTRAINT [FK_FabEtaRes_FabEtapa] FOREIGN KEY ([RucE], [Cd_Fab], [ID_Eta]) REFERENCES [dbo].[FabEtapa] ([RucE], [Cd_Fab], [ID_Eta])
GO
ALTER TABLE [dbo].[FabEtaRes] ADD CONSTRAINT [FK_FabEtaRes_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabEtaRes', 'COLUMN', N'Costo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabEtaRes', 'COLUMN', N'Costo_ME'
GO
