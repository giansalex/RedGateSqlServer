CREATE TABLE [dbo].[FrmlaOF]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OF] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[CU] [numeric] (15, 7) NULL,
[CU_ME] [numeric] (15, 7) NULL,
[Cant] [numeric] (15, 7) NOT NULL,
[Costo] [numeric] (15, 7) NULL,
[Costo_ME] [numeric] (15, 7) NULL,
[Mer] [numeric] (16, 6) NULL,
[MerPorc] [numeric] (6, 3) NULL,
[Obs] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Cos] [char] (2) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FrmlaOF] ADD CONSTRAINT [PK_FrmlaOF] PRIMARY KEY CLUSTERED  ([RucE], [Cd_OF], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FrmlaOF] ADD CONSTRAINT [FK_FrmlaOF_CptoCosto] FOREIGN KEY ([RucE], [Cd_Cos]) REFERENCES [dbo].[CptoCosto] ([RucE], [Cd_Cos])
GO
ALTER TABLE [dbo].[FrmlaOF] WITH NOCHECK ADD CONSTRAINT [FK_FrmlaOF_OrdFabricacion] FOREIGN KEY ([RucE], [Cd_OF]) REFERENCES [dbo].[OrdFabricacion] ([RucE], [Cd_OF])
GO
EXEC sp_addextendedproperty N'MS_Description', N'OC00000001', 'SCHEMA', N'dbo', 'TABLE', N'FrmlaOF', 'COLUMN', N'Cd_OF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Merma', 'SCHEMA', N'dbo', 'TABLE', N'FrmlaOF', 'COLUMN', N'Mer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Porcentaje Merma', 'SCHEMA', N'dbo', 'TABLE', N'FrmlaOF', 'COLUMN', N'MerPorc'
GO
