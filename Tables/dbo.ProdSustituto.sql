CREATE TABLE [dbo].[ProdSustituto]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ProdB] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ProdS] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProdSustituto] ADD CONSTRAINT [IX_ProdSustituto_Ruc_CdPB_CdPS] UNIQUE NONCLUSTERED  ([RucE], [Cd_ProdB], [Cd_ProdS]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProdSustituto] WITH NOCHECK ADD CONSTRAINT [FK_ProdSustituto_Producto2] FOREIGN KEY ([RucE], [Cd_ProdB]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
ALTER TABLE [dbo].[ProdSustituto] WITH NOCHECK ADD CONSTRAINT [FK_ProdSustituto_Producto2_1] FOREIGN KEY ([RucE], [Cd_ProdS]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prod. Base', 'SCHEMA', N'dbo', 'TABLE', N'ProdSustituto', 'COLUMN', N'Cd_ProdB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prod. Sustituto', 'SCHEMA', N'dbo', 'TABLE', N'ProdSustituto', 'COLUMN', N'Cd_ProdS'
GO
