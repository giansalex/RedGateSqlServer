CREATE TABLE [dbo].[MovimientoPtoVta]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Mov] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[MontoAPagar] [decimal] (20, 7) NOT NULL,
[MontoPagado] [decimal] (20, 7) NOT NULL,
[Saldo] [decimal] (18, 7) NOT NULL,
[SaldoAcumulado] [decimal] (18, 7) NOT NULL,
[FechaMovimiento] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MovimientoPtoVta] ADD CONSTRAINT [PK_MovimientoPtoVta] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Vta], [Cd_Mov]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MovimientoPtoVta] ADD CONSTRAINT [FK_MovimientoPtoVta_Venta] FOREIGN KEY ([RucE], [Cd_Vta]) REFERENCES [dbo].[Venta] ([RucE], [Cd_Vta])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Movimientos en Punto de Venta', 'SCHEMA', N'dbo', 'TABLE', N'MovimientoPtoVta', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Puede ser negativo si es que en el movimiento se toma del saldo para cancelar un movimiento', 'SCHEMA', N'dbo', 'TABLE', N'MovimientoPtoVta', 'COLUMN', N'Saldo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nunca puede ser menor a cero.', 'SCHEMA', N'dbo', 'TABLE', N'MovimientoPtoVta', 'COLUMN', N'SaldoAcumulado'
GO
