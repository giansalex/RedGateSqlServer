CREATE TABLE [dbo].[PrecioHist]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Id_PHist] [int] NOT NULL,
[ID_Prec] [int] NOT NULL,
[Fecha] [smalldatetime] NOT NULL,
[PVta] [numeric] (13, 2) NULL,
[IB_IncIGV] [bit] NULL,
[IB_Exrdo] [bit] NULL,
[ValVta] [numeric] (13, 2) NULL,
[IC_TipDscto] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Dscto] [numeric] (13, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PrecioHist] ADD CONSTRAINT [PK_PrecioHist] PRIMARY KEY CLUSTERED  ([RucE], [Id_PHist]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PrecioHist] WITH NOCHECK ADD CONSTRAINT [FK_PrecioHist_Precio] FOREIGN KEY ([RucE], [ID_Prec]) REFERENCES [dbo].[Precio] ([RucE], [ID_Prec])
GO
EXEC sp_addextendedproperty N'MS_Description', N'fecha con hora', 'SCHEMA', N'dbo', 'TABLE', N'PrecioHist', 'COLUMN', N'Fecha'
GO
