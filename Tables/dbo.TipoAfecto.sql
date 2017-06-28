CREATE TABLE [dbo].[TipoAfecto]
(
[Cd_TipAfec] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomCorto] [varchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
