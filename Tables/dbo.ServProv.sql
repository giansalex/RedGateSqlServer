CREATE TABLE [dbo].[ServProv]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CodigoAlt] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[DescripAlt] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServProv] ADD CONSTRAINT [PK_ServProv] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Prv], [Cd_Srv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServProv] WITH NOCHECK ADD CONSTRAINT [FK_ServProv_Proveedor2] FOREIGN KEY ([RucE], [Cd_Prv]) REFERENCES [dbo].[Proveedor2] ([RucE], [Cd_Prv])
GO
ALTER TABLE [dbo].[ServProv] WITH NOCHECK ADD CONSTRAINT [FK_ServProv_Servicio2] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRC0001', 'SCHEMA', N'dbo', 'TABLE', N'ServProv', 'COLUMN', N'Cd_Srv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Comercial del Prov.', 'SCHEMA', N'dbo', 'TABLE', N'ServProv', 'COLUMN', N'CodigoAlt'
GO
