CREATE TABLE [dbo].[CptoCostoOFDoc]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OF] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Id_CCOF] [int] NOT NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[NroCta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CstAsig] [numeric] (15, 7) NULL,
[Cd_Mda] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (6, 3) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CptoCostoOFDoc] ADD CONSTRAINT [FK_CptoCostoOFDoc_CptoCostoOF] FOREIGN KEY ([RucE], [Cd_OF], [Id_CCOF]) REFERENCES [dbo].[CptoCostoOF] ([RucE], [Cd_OF], [Id_CCOF])
GO
EXEC sp_addextendedproperty N'MS_Description', N'OF00000001', 'SCHEMA', N'dbo', 'TABLE', N'CptoCostoOFDoc', 'COLUMN', N'Cd_OF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Costo Asignado', 'SCHEMA', N'dbo', 'TABLE', N'CptoCostoOFDoc', 'COLUMN', N'CstAsig'
GO
