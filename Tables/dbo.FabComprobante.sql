CREATE TABLE [dbo].[FabComprobante]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Fab] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Com] [int] NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroCta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CostoAsig] [numeric] (15, 7) NULL,
[CostoAsig_ME] [numeric] (15, 7) NULL,
[Cd_Cos] [char] (2) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabComprobante] ADD CONSTRAINT [PK_FabComprobante_1] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Fab], [ID_Com]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabComprobante] ADD CONSTRAINT [FK_FabComprobante_FabFabricacion] FOREIGN KEY ([RucE], [Cd_Fab]) REFERENCES [dbo].[FabFabricacion] ([RucE], [Cd_Fab])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabComprobante', 'COLUMN', N'CostoAsig'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabComprobante', 'COLUMN', N'CostoAsig_ME'
GO
