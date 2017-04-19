CREATE TABLE [dbo].[AmarreCta]
(
[Item] [int] NOT NULL,
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[NroCta] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CtaD] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CtaH] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Porc] [numeric] (5, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AmarreCta] ADD CONSTRAINT [PK_AmarreCta_1] PRIMARY KEY CLUSTERED  ([Item], [RucE]) ON [PRIMARY]
GO
