CREATE TABLE [dbo].[CfgAyudas]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TM] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CodInt] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DispCod] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgAyudas] ADD CONSTRAINT [FK_CfgAyudas_TipMant] FOREIGN KEY ([RucE], [Cd_TM]) REFERENCES [dbo].[TipMant] ([RucE], [Cd_TM])
GO
