CREATE TABLE [dbo].[TipAlert]
(
[Cd_TA] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL,
[Cd_IAlert] [char] (2) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipAlert] ADD CONSTRAINT [PK_TipAlert] PRIMARY KEY CLUSTERED  ([Cd_TA]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipAlert] ADD CONSTRAINT [FK_TipAlert_IndicadorAlert] FOREIGN KEY ([Cd_IAlert]) REFERENCES [dbo].[IndicadorAlert] ([Cd_IAlert])
GO
