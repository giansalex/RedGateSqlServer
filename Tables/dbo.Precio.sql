CREATE TABLE [dbo].[Precio]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Prec] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
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
[IC_TipMU] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[MrgUti] [numeric] (13, 4) NULL,
[Estado] [bit] NOT NULL,
[IB_EsPrin] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Precio] ADD CONSTRAINT [PK_Precio] PRIMARY KEY CLUSTERED  ([RucE], [ID_Prec]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Precio] WITH NOCHECK ADD CONSTRAINT [FK_Precio_Moneda] FOREIGN KEY ([Cd_Mda]) REFERENCES [dbo].[Moneda] ([Cd_Mda])
GO
ALTER TABLE [dbo].[Precio] WITH NOCHECK ADD CONSTRAINT [FK_Precio_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Habilitado/Deshabilitado', 'SCHEMA', N'dbo', 'TABLE', N'Precio', 'COLUMN', N'Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador es principal', 'SCHEMA', N'dbo', 'TABLE', N'Precio', 'COLUMN', N'IB_EsPrin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ttipo Margen Utilidad (Porc/Imp)', 'SCHEMA', N'dbo', 'TABLE', N'Precio', 'COLUMN', N'IC_TipMU'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Variacion Precio  (Porc/Imp)', 'SCHEMA', N'dbo', 'TABLE', N'Precio', 'COLUMN', N'IC_TipVP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Margen Inferior', 'SCHEMA', N'dbo', 'TABLE', N'Precio', 'COLUMN', N'MrgInf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Margen Superior', 'SCHEMA', N'dbo', 'TABLE', N'Precio', 'COLUMN', N'MrgSup'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Margen Utilidad', 'SCHEMA', N'dbo', 'TABLE', N'Precio', 'COLUMN', N'MrgUti'
GO
