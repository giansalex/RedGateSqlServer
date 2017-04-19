CREATE TABLE [dbo].[ImpPorcProd]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_IP] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL CONSTRAINT [DF_ImpPorcProd_Cd_IP] DEFAULT (N'Codigo Compra'),
[Item] [int] NOT NULL,
[ItemIC] [int] NOT NULL,
[CstAsig] [numeric] (13, 4) NULL,
[CstAsig_ME] [numeric] (13, 4) NULL,
[PorcAsig] [numeric] (7, 4) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImpPorcProd] ADD CONSTRAINT [PK_ImpPorcProd] PRIMARY KEY CLUSTERED  ([RucE], [Cd_IP], [Item], [ItemIC]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImpPorcProd] ADD CONSTRAINT [FK_ImpPorcProd_ImpComp] FOREIGN KEY ([RucE], [Cd_IP], [ItemIC]) REFERENCES [dbo].[ImpComp] ([RucE], [Cd_IP], [ItemIC])
GO
EXEC sp_addextendedproperty N'MS_Description', N'CM00000001', 'SCHEMA', N'dbo', 'TABLE', N'ImpPorcProd', 'COLUMN', N'Cd_IP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CM00000001', 'SCHEMA', N'dbo', 'TABLE', N'ImpPorcProd', 'COLUMN', N'ItemIC'
GO
