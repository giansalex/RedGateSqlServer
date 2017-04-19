CREATE TABLE [dbo].[TipoMov]
(
[Cd_TM] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (8) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipoMov] ADD CONSTRAINT [PK_TipoMov] PRIMARY KEY CLUSTERED  ([Cd_TM]) ON [PRIMARY]
GO
