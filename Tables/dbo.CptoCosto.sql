CREATE TABLE [dbo].[CptoCosto]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cos] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CodSNT_] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[IB_Prin] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CptoCosto] ADD CONSTRAINT [PK_CptoCosto] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Cos]) ON [PRIMARY]
GO
