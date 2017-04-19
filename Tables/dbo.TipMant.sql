CREATE TABLE [dbo].[TipMant]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TM] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Es_MntGN] [bit] NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipMant] ADD CONSTRAINT [PK_TipMant] PRIMARY KEY CLUSTERED  ([RucE], [Cd_TM]) ON [PRIMARY]
GO
