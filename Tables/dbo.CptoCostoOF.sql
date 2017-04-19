CREATE TABLE [dbo].[CptoCostoOF]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OF] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Id_CCOF] [int] NOT NULL,
[Cd_Cos] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Costo] [numeric] (15, 7) NULL,
[Costo_ME] [numeric] (15, 7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CptoCostoOF] ADD CONSTRAINT [PK_CptoCostoOF] PRIMARY KEY CLUSTERED  ([RucE], [Cd_OF], [Id_CCOF]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CptoCostoOF] WITH NOCHECK ADD CONSTRAINT [FK_CptoCostoOF_CptoCosto] FOREIGN KEY ([RucE], [Cd_Cos]) REFERENCES [dbo].[CptoCosto] ([RucE], [Cd_Cos])
GO
ALTER TABLE [dbo].[CptoCostoOF] WITH NOCHECK ADD CONSTRAINT [FK_CptoCostoOF_OrdFabricacion] FOREIGN KEY ([RucE], [Cd_OF]) REFERENCES [dbo].[OrdFabricacion] ([RucE], [Cd_OF])
GO
EXEC sp_addextendedproperty N'MS_Description', N'OF00000001', 'SCHEMA', N'dbo', 'TABLE', N'CptoCostoOF', 'COLUMN', N'Cd_OF'
GO
