CREATE TABLE [dbo].[CanjePagoDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cnj] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Com] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
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
ALTER TABLE [dbo].[CanjePagoDet] ADD CONSTRAINT [PK_CanjePagoDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Cnj], [Item]) ON [PRIMARY]
GO
