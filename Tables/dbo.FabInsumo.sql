CREATE TABLE [dbo].[FabInsumo]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Flujo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Prc] [int] NOT NULL,
[ID_Ins] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[Cant] [numeric] (15, 7) NULL,
[Merma] [numeric] (15, 7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabInsumo] ADD CONSTRAINT [PK_PrdInsumo] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Flujo], [ID_Prc], [ID_Ins]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabInsumo] ADD CONSTRAINT [FK_PrdInsumo_PrdProceso] FOREIGN KEY ([RucE], [Cd_Flujo], [ID_Prc]) REFERENCES [dbo].[FabProceso] ([RucE], [Cd_Flujo], [ID_Prc])
GO
ALTER TABLE [dbo].[FabInsumo] ADD CONSTRAINT [FK_PrdInsumo_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
