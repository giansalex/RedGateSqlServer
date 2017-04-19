CREATE TABLE [dbo].[SeriesXArea]
(
[Itm_SA] [int] NOT NULL,
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Sr] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SeriesXArea] ADD CONSTRAINT [PK_SeriesXArea] PRIMARY KEY CLUSTERED  ([Itm_SA], [RucE]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SeriesXArea] ADD CONSTRAINT [IX_SeriesXArea_UNIQUE] UNIQUE NONCLUSTERED  ([RucE], [Cd_Area], [Cd_Sr]) ON [PRIMARY]
GO
