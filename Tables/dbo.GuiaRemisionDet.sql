CREATE TABLE [dbo].[GuiaRemisionDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_GR] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Cant] [numeric] (13, 3) NULL,
[PesoCantKg] [numeric] (18, 3) NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Com] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[ItemPd] [int] NULL,
[Pend] [numeric] (13, 3) NULL,
[FecMdf] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_OP] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GuiaRemisionDet] ADD CONSTRAINT [PK_GuiaRemisionDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_GR], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GuiaRemisionDet] WITH NOCHECK ADD CONSTRAINT [FK_GuiaRemisionDet_GuiaRemision] FOREIGN KEY ([RucE], [Cd_GR]) REFERENCES [dbo].[GuiaRemision] ([RucE], [Cd_GR])
GO
ALTER TABLE [dbo].[GuiaRemisionDet] WITH NOCHECK ADD CONSTRAINT [FK_GuiaRemisionDet_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
ALTER TABLE [dbo].[GuiaRemisionDet] WITH NOCHECK ADD CONSTRAINT [FK_GuiaRemisionDet_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrip para prod. no propios', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemisionDet', 'COLUMN', N'Descrip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item x Ruc_GR', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemisionDet', 'COLUMN', N'Item'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item Prod. Venta/Compra', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemisionDet', 'COLUMN', N'ItemPd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'(Ya no va) Pendientes de pasar a guia', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemisionDet', 'COLUMN', N'Pend'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub total peso (Peso Prod x Cant)', 'SCHEMA', N'dbo', 'TABLE', N'GuiaRemisionDet', 'COLUMN', N'PesoCantKg'
GO
