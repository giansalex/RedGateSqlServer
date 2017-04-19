CREATE TABLE [dbo].[Serie]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Sr] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroSerie] [nvarchar] (5) COLLATE Modern_Spanish_CI_AS NOT NULL,
[PtoEmision] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Serie] ADD CONSTRAINT [PK_Serie] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Sr]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Serie] ADD CONSTRAINT [IX_Serie] UNIQUE NONCLUSTERED  ([RucE], [Cd_TD], [NroSerie]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Serie] WITH NOCHECK ADD CONSTRAINT [FK_Serie_TipDoc] FOREIGN KEY ([Cd_TD]) REFERENCES [dbo].[TipDoc] ([Cd_TD])
GO
