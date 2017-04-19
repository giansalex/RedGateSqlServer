CREATE TABLE [dbo].[CarteraProdDet_P]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Ct] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CarteraProdDet_P] ADD CONSTRAINT [IX_CatalogoProd__RucE_CdCt_CdPd] UNIQUE NONCLUSTERED  ([RucE], [Cd_Ct], [Cd_Prod]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CarteraProdDet_P] WITH NOCHECK ADD CONSTRAINT [FK_CatalogoProd_Catalogo] FOREIGN KEY ([RucE], [Cd_Ct]) REFERENCES [dbo].[CarteraProd] ([RucE], [Cd_Ct])
GO
ALTER TABLE [dbo].[CarteraProdDet_P] WITH NOCHECK ADD CONSTRAINT [FK_CatalogoProd_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Catalogo', 'SCHEMA', N'dbo', 'TABLE', N'CarteraProdDet_P', 'COLUMN', N'Cd_Ct'
GO
