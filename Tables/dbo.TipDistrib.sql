CREATE TABLE [dbo].[TipDistrib]
(
[Cd_TipDist] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipDistrib] ADD CONSTRAINT [PK_TipDistrib] PRIMARY KEY CLUSTERED  ([Cd_TipDist]) ON [PRIMARY]
GO
