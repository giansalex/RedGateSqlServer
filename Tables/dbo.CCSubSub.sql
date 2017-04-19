CREATE TABLE [dbo].[CCSubSub]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Psp] [bit] NULL,
[CA01] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CCSubSub] ADD CONSTRAINT [PK_CCSubSub] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CC], [Cd_SC], [Cd_SS]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CCSubSub] WITH NOCHECK ADD CONSTRAINT [FK_CCSubSub_CCSub] FOREIGN KEY ([RucE], [Cd_CC], [Cd_SC]) REFERENCES [dbo].[CCSub] ([RucE], [Cd_CC], [Cd_SC])
GO
