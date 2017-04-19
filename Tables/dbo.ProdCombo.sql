CREATE TABLE [dbo].[ProdCombo]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ProdB] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ProdC] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cant] [numeric] (13, 3) NOT NULL,
[ID_UMP] [int] NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProdCombo] ADD CONSTRAINT [IX_ProdCombo_Ruc_CdPB_CdPC_IDUMP] UNIQUE NONCLUSTERED  ([RucE], [Cd_ProdB], [Cd_ProdC], [ID_UMP]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProdCombo] WITH NOCHECK ADD CONSTRAINT [FK_ProdCombo_Prod_UM] FOREIGN KEY ([RucE], [Cd_ProdC], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[ProdCombo] WITH NOCHECK ADD CONSTRAINT [FK_ProdCombo_Producto2] FOREIGN KEY ([RucE], [Cd_ProdB]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
ALTER TABLE [dbo].[ProdCombo] WITH NOCHECK ADD CONSTRAINT [FK_ProdCombo_Producto2_Cd_ProdC] FOREIGN KEY ([RucE], [Cd_ProdC]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prod. Base', 'SCHEMA', N'dbo', 'TABLE', N'ProdCombo', 'COLUMN', N'Cd_ProdB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prod. Combo', 'SCHEMA', N'dbo', 'TABLE', N'ProdCombo', 'COLUMN', N'Cd_ProdC'
GO
