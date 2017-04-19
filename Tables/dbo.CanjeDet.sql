CREATE TABLE [dbo].[CanjeDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cnj] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vou] [int] NULL,
[Cd_Ltr] [int] NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[NroSre] [nvarchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Importe] [numeric] (13, 2) NULL,
[DsctPor] [numeric] (5, 2) NULL,
[DsctImp] [numeric] (13, 2) NULL,
[Total] [numeric] (13, 2) NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CanjeDet] ADD CONSTRAINT [PK_CanjeDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Cnj], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CanjeDet] ADD CONSTRAINT [FK_CanjeDet_Canje] FOREIGN KEY ([RucE], [Cd_Cnj]) REFERENCES [dbo].[Canje] ([RucE], [Cd_Cnj])
GO
ALTER TABLE [dbo].[CanjeDet] WITH NOCHECK ADD CONSTRAINT [FK_CanjeDet_Letra_Cobro] FOREIGN KEY ([RucE], [Cd_Ltr]) REFERENCES [dbo].[Letra_Cobro] ([RucE], [Cd_Ltr])
GO
ALTER TABLE [dbo].[CanjeDet] WITH NOCHECK ADD CONSTRAINT [FK_CanjeDet_Voucher] FOREIGN KEY ([RucE], [Cd_Vou]) REFERENCES [dbo].[Voucher] ([RucE], [Cd_Vou])
GO
ALTER TABLE [dbo].[CanjeDet] NOCHECK CONSTRAINT [FK_CanjeDet_Letra_Cobro]
GO
ALTER TABLE [dbo].[CanjeDet] NOCHECK CONSTRAINT [FK_CanjeDet_Voucher]
GO
