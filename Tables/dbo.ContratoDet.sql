CREATE TABLE [dbo].[ContratoDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Ctt] [int] NOT NULL,
[Item] [int] NOT NULL,
[IC_TipDet] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[FecDef] [smalldatetime] NULL,
[ValorDef] [numeric] (13, 2) NULL,
[IC_TipVal] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[ValorAgr] [numeric] (13, 3) NULL,
[TotalDef] [numeric] (13, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ContratoDet] ADD CONSTRAINT [PK_ContratoDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Ctt], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ContratoDet] ADD CONSTRAINT [FK_ContratoDet_Contrato] FOREIGN KEY ([RucE], [Cd_Ctt]) REFERENCES [dbo].[Contrato] ([RucE], [Cd_Ctt])
GO
