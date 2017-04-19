CREATE TABLE [dbo].[GuiaXVenta]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_GR] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GuiaXVenta] WITH NOCHECK ADD CONSTRAINT [FK_GuiaXVenta_GuiaRemision] FOREIGN KEY ([RucE], [Cd_GR]) REFERENCES [dbo].[GuiaRemision] ([RucE], [Cd_GR])
GO
ALTER TABLE [dbo].[GuiaXVenta] WITH NOCHECK ADD CONSTRAINT [FK_GuiaXVenta_Venta] FOREIGN KEY ([RucE], [Cd_Vta]) REFERENCES [dbo].[Venta] ([RucE], [Cd_Vta])
GO
EXEC sp_addextendedproperty N'MS_Description', N'GR00000001', 'SCHEMA', N'dbo', 'TABLE', N'GuiaXVenta', 'COLUMN', N'Cd_GR'
GO
