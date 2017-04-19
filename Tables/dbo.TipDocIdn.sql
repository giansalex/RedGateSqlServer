CREATE TABLE [dbo].[TipDocIdn]
(
[Cd_TDI] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipDocIdn] ADD CONSTRAINT [PK_TipDocIdn] PRIMARY KEY CLUSTERED  ([Cd_TDI]) ON [PRIMARY]
GO
