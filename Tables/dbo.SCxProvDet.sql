CREATE TABLE [dbo].[SCxProvDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SCoEnv] [int] NOT NULL,
[Cd_Prov] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Item] [int] NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cant] [numeric] (13, 3) NULL,
[Cd_Mda] [varchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Precio] [numeric] (13, 2) NULL,
[Total] [numeric] (13, 2) NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Acp] [bit] NULL,
[FecCrea] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SCxProvDet] ADD CONSTRAINT [FK_SCxProvDet_SCxProv] FOREIGN KEY ([RucE], [Cd_SCoEnv]) REFERENCES [dbo].[SCxProv] ([RucE], [Cd_SCoEnv])
GO
