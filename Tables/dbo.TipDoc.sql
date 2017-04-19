CREATE TABLE [dbo].[TipDoc]
(
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipDoc] ADD CONSTRAINT [PK_TipDoc] PRIMARY KEY CLUSTERED  ([Cd_TD]) ON [PRIMARY]
GO
