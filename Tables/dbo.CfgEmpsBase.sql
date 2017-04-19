CREATE TABLE [dbo].[CfgEmpsBase]
(
[RucBase] [char] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [char] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgEmpsBase] ADD CONSTRAINT [PK_CfgEmpsBase] PRIMARY KEY CLUSTERED  ([RucBase]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgEmpsBase] ADD CONSTRAINT [IX_CfgEmpsBase_Descrip] UNIQUE NONCLUSTERED  ([Descrip]) ON [PRIMARY]
GO
