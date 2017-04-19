CREATE TABLE [dbo].[IndicadorAfecto]
(
[Cd_IA] [char] (1) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomCorto] [varchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
