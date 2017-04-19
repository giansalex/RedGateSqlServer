CREATE TABLE [dbo].[PrecioSrv]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_PrSv] [int] NOT NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[PVta] [numeric] (13, 4) NULL,
[IB_IncIGV] [bit] NULL,
[IB_Exrdo] [bit] NULL,
[ValVta] [numeric] (13, 4) NULL,
[IC_TipDscto] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Dscto] [numeric] (13, 4) NULL,
[IC_TipVP] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL,
[MrgInf] [numeric] (13, 4) NULL,
[MrgSup] [numeric] (13, 4) NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PrecioSrv] ADD CONSTRAINT [PK_PrecioSrv] PRIMARY KEY CLUSTERED  ([RucE], [ID_PrSv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PrecioSrv] WITH NOCHECK ADD CONSTRAINT [FK_PrecioSrv_Servicio2] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Variacion Precio', 'SCHEMA', N'dbo', 'TABLE', N'PrecioSrv', 'COLUMN', N'IC_TipVP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id Precio Servicio', 'SCHEMA', N'dbo', 'TABLE', N'PrecioSrv', 'COLUMN', N'ID_PrSv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Margen Inferior', 'SCHEMA', N'dbo', 'TABLE', N'PrecioSrv', 'COLUMN', N'MrgInf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Margen Superior', 'SCHEMA', N'dbo', 'TABLE', N'PrecioSrv', 'COLUMN', N'MrgSup'
GO
