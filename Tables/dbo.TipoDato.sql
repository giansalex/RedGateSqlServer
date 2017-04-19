CREATE TABLE [dbo].[TipoDato]
(
[Id_TDt] [int] NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipoDato] ADD CONSTRAINT [PK_TipoDato] PRIMARY KEY CLUSTERED  ([Id_TDt]) ON [PRIMARY]
GO
