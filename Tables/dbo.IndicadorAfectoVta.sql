CREATE TABLE [dbo].[IndicadorAfectoVta]
(
[Cd_IAV] [char] (1) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomCorto] [varchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IndicadorAfectoVta] ADD CONSTRAINT [PK_IndicadorAfectoVta] PRIMARY KEY CLUSTERED  ([Cd_IAV]) ON [PRIMARY]
GO
