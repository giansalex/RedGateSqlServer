CREATE TABLE [dbo].[Anexo]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Ctt] [int] NOT NULL,
[Cd_Anx] [int] NOT NULL,
[Ruta] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA11] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA12] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA13] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA14] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA15] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Anexo] ADD CONSTRAINT [FK_Anexo_Contrato] FOREIGN KEY ([RucE], [Cd_Ctt]) REFERENCES [dbo].[Contrato] ([RucE], [Cd_Ctt])
GO
