CREATE TABLE [dbo].[CfgCaja]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Caja] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Itm_CC] [int] NOT NULL,
[Cd_MIS] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[CtaBco] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[CtaClt] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_MIS_Inv] [char] (3) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgCaja] ADD CONSTRAINT [PK_CfgCaja] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Caja], [Itm_CC]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgCaja] ADD CONSTRAINT [FK_CfgCaja_Almacen] FOREIGN KEY ([RucE], [Cd_Alm]) REFERENCES [dbo].[Almacen] ([RucE], [Cd_Alm])
GO
ALTER TABLE [dbo].[CfgCaja] ADD CONSTRAINT [FK_CfgCaja_Caja] FOREIGN KEY ([RucE], [Cd_Caja]) REFERENCES [dbo].[Caja] ([RucE], [Cd_Caja])
GO
ALTER TABLE [dbo].[CfgCaja] ADD CONSTRAINT [FK_CfgCaja_CCSubSub] FOREIGN KEY ([RucE], [Cd_CC], [Cd_SC], [Cd_SS]) REFERENCES [dbo].[CCSubSub] ([RucE], [Cd_CC], [Cd_SC], [Cd_SS])
GO
ALTER TABLE [dbo].[CfgCaja] ADD CONSTRAINT [FK_CfgCaja_MtvoIngSal] FOREIGN KEY ([RucE], [Cd_MIS]) REFERENCES [dbo].[MtvoIngSal] ([RucE], [Cd_MIS])
GO
ALTER TABLE [dbo].[CfgCaja] ADD CONSTRAINT [FK_CfgCaja_MtvoIngSal1] FOREIGN KEY ([RucE], [Cd_MIS_Inv]) REFERENCES [dbo].[MtvoIngSal] ([RucE], [Cd_MIS])
GO
