CREATE TABLE [dbo].[AlmacenStock]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CantAlm] [numeric] (13, 3) NULL,
[CantCtb] [numeric] (13, 3) NULL,
[PendRcb] [numeric] (13, 3) NULL,
[PendEnt] [numeric] (13, 3) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AlmacenStock] ADD CONSTRAINT [IX_AlmacenStock__Ruc_CdAl_CdPd] UNIQUE NONCLUSTERED  ([RucE], [Cd_Alm], [Cd_Prod]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AlmacenStock] WITH NOCHECK ADD CONSTRAINT [FK_AlmacenStock_Almacen] FOREIGN KEY ([RucE], [Cd_Alm]) REFERENCES [dbo].[Almacen] ([RucE], [Cd_Alm])
GO
ALTER TABLE [dbo].[AlmacenStock] WITH NOCHECK ADD CONSTRAINT [FK_AlmacenStock_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Almacen', 'SCHEMA', N'dbo', 'TABLE', N'AlmacenStock', 'COLUMN', N'Cd_Alm'
GO
