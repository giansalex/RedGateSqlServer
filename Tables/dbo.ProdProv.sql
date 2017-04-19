CREATE TABLE [dbo].[ProdProv]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[CodigoAlt] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[DescripAlt] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProdProv] ADD CONSTRAINT [PK_ProdProv] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Prv], [Cd_Prod], [ID_UMP]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProdProv] ADD CONSTRAINT [FK_ProdProv_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[ProdProv] WITH NOCHECK ADD CONSTRAINT [FK_ProdProv_Proveedor2] FOREIGN KEY ([RucE], [Cd_Prv]) REFERENCES [dbo].[Proveedor2] ([RucE], [Cd_Prv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Forma Presentacion', 'SCHEMA', N'dbo', 'TABLE', N'ProdProv', 'COLUMN', N'CA01'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Calidad', 'SCHEMA', N'dbo', 'TABLE', N'ProdProv', 'COLUMN', N'CA02'
GO
EXEC sp_addextendedproperty N'MS_Description', N'etc.', 'SCHEMA', N'dbo', 'TABLE', N'ProdProv', 'COLUMN', N'CA03'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Algun codigo que maneje el proveedor', 'SCHEMA', N'dbo', 'TABLE', N'ProdProv', 'COLUMN', N'CodigoAlt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrip del prod. que le da el proveedor', 'SCHEMA', N'dbo', 'TABLE', N'ProdProv', 'COLUMN', N'DescripAlt'
GO
