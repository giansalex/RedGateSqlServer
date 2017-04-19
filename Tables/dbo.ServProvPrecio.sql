CREATE TABLE [dbo].[ServProvPrecio]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_PrecSP] [int] NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Fecha] [smalldatetime] NOT NULL,
[PrecioCom] [numeric] (13, 2) NOT NULL,
[IB_IncIGV] [bit] NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServProvPrecio] ADD CONSTRAINT [PK_ServProvPrecio] PRIMARY KEY CLUSTERED  ([RucE], [ID_PrecSP]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServProvPrecio] WITH NOCHECK ADD CONSTRAINT [FK_ServProvPrecio_ServProv] FOREIGN KEY ([RucE], [Cd_Prv], [Cd_Srv]) REFERENCES [dbo].[ServProv] ([RucE], [Cd_Prv], [Cd_Srv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRC0001', 'SCHEMA', N'dbo', 'TABLE', N'ServProvPrecio', 'COLUMN', N'Cd_Srv'
GO
