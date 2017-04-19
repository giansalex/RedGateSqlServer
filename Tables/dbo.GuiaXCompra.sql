CREATE TABLE [dbo].[GuiaXCompra]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_GR] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Com] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GuiaXCompra] WITH NOCHECK ADD CONSTRAINT [FK_GuiaXCompra_Compra] FOREIGN KEY ([RucE], [Cd_Com]) REFERENCES [dbo].[Compra] ([RucE], [Cd_Com])
GO
ALTER TABLE [dbo].[GuiaXCompra] WITH NOCHECK ADD CONSTRAINT [FK_GuiaXCompra_GuiaRemision] FOREIGN KEY ([RucE], [Cd_GR]) REFERENCES [dbo].[GuiaRemision] ([RucE], [Cd_GR])
GO
EXEC sp_addextendedproperty N'MS_Description', N'CM00000001', 'SCHEMA', N'dbo', 'TABLE', N'GuiaXCompra', 'COLUMN', N'Cd_Com'
GO
EXEC sp_addextendedproperty N'MS_Description', N'GR00000001', 'SCHEMA', N'dbo', 'TABLE', N'GuiaXCompra', 'COLUMN', N'Cd_GR'
GO
