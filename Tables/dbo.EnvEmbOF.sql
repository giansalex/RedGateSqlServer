CREATE TABLE [dbo].[EnvEmbOF]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OF] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[CU] [numeric] (15, 7) NULL,
[CU_ME] [numeric] (15, 7) NULL,
[Cant] [numeric] (15, 7) NOT NULL,
[Costo] [numeric] (15, 7) NULL,
[Costo_ME] [numeric] (15, 7) NULL,
[Cd_Cos] [char] (2) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EnvEmbOF] ADD CONSTRAINT [FK_EnvEmbOF_CptoCosto] FOREIGN KEY ([RucE], [Cd_Cos]) REFERENCES [dbo].[CptoCosto] ([RucE], [Cd_Cos])
GO
ALTER TABLE [dbo].[EnvEmbOF] WITH NOCHECK ADD CONSTRAINT [FK_EnvEmbOF_OrdFabricacion] FOREIGN KEY ([RucE], [Cd_OF]) REFERENCES [dbo].[OrdFabricacion] ([RucE], [Cd_OF])
GO
EXEC sp_addextendedproperty N'MS_Description', N'OF00000001', 'SCHEMA', N'dbo', 'TABLE', N'EnvEmbOF', 'COLUMN', N'Cd_OF'
GO
