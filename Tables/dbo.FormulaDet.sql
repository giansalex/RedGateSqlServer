CREATE TABLE [dbo].[FormulaDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Fmla] [int] NOT NULL,
[Item] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[Cant] [numeric] (16, 6) NOT NULL,
[Mer] [numeric] (16, 6) NULL,
[MerPorc] [numeric] (6, 3) NULL,
[Obs] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Cos] [char] (2) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FormulaDet] ADD CONSTRAINT [PK_FormulaDet] PRIMARY KEY CLUSTERED  ([RucE], [ID_Fmla], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FormulaDet] ADD CONSTRAINT [FK_FormulaDet_CptoCosto] FOREIGN KEY ([RucE], [Cd_Cos]) REFERENCES [dbo].[CptoCosto] ([RucE], [Cd_Cos])
GO
ALTER TABLE [dbo].[FormulaDet] WITH NOCHECK ADD CONSTRAINT [FK_FormulaDet_Formula] FOREIGN KEY ([RucE], [ID_Fmla]) REFERENCES [dbo].[Formula] ([RucE], [ID_Fmla]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FormulaDet] WITH NOCHECK ADD CONSTRAINT [FK_FormulaDet_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Merma', 'SCHEMA', N'dbo', 'TABLE', N'FormulaDet', 'COLUMN', N'Mer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Porcentaje Merma', 'SCHEMA', N'dbo', 'TABLE', N'FormulaDet', 'COLUMN', N'MerPorc'
GO
