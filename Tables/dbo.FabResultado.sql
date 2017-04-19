CREATE TABLE [dbo].[FabResultado]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Flujo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Prc] [int] NOT NULL,
[ID_Rest] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[Cant] [numeric] (15, 7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabResultado] ADD CONSTRAINT [PK_FabResultado] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Flujo], [ID_Prc], [ID_Rest]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabResultado] ADD CONSTRAINT [FK_FabResultado_FabProceso] FOREIGN KEY ([RucE], [Cd_Flujo], [ID_Prc]) REFERENCES [dbo].[FabProceso] ([RucE], [Cd_Flujo], [ID_Prc])
GO
ALTER TABLE [dbo].[FabResultado] ADD CONSTRAINT [FK_PrdResultado_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
