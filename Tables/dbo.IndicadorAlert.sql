CREATE TABLE [dbo].[IndicadorAlert]
(
[Cd_IAlert] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IndicadorAlert] ADD CONSTRAINT [PK_IndicadorAlert] PRIMARY KEY CLUSTERED  ([Cd_IAlert]) ON [PRIMARY]
GO
