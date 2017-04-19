CREATE TABLE [dbo].[ConceptoDetracHist]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CDtr] [char] (4) COLLATE Modern_Spanish_CI_AS NULL,
[FecVig] [smalldatetime] NOT NULL,
[Porc] [numeric] (6, 3) NULL,
[MtoDtr] [numeric] (13, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoDetracHist] ADD CONSTRAINT [FK_ConceptoDetracHist_ConceptosDetrac] FOREIGN KEY ([RucE], [Cd_CDtr]) REFERENCES [dbo].[ConceptosDetrac] ([RucE], [Cd_CDtr])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la que se puso vigente', 'SCHEMA', N'dbo', 'TABLE', N'ConceptoDetracHist', 'COLUMN', N'FecVig'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto minimo para detraer', 'SCHEMA', N'dbo', 'TABLE', N'ConceptoDetracHist', 'COLUMN', N'MtoDtr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'% de detraacion', 'SCHEMA', N'dbo', 'TABLE', N'ConceptoDetracHist', 'COLUMN', N'Porc'
GO
