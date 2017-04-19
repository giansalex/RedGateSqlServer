CREATE TABLE [dbo].[ImpComp]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_IP] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ItemIC] [int] NOT NULL,
[RegCtb] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[NroCta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (6, 3) NULL,
[CstAsig] [numeric] (13, 2) NULL,
[CstAsig_ME] [numeric] (13, 2) NULL,
[PorcAsig] [numeric] (7, 2) NULL,
[Cd_TipDist] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[TipGasto] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[TipInconterms] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImpComp] ADD CONSTRAINT [PK_ImpComp] PRIMARY KEY CLUSTERED  ([RucE], [Cd_IP], [ItemIC]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImpComp] ADD CONSTRAINT [FK_ImpComp_Importacion] FOREIGN KEY ([RucE], [Cd_IP]) REFERENCES [dbo].[Importacion] ([RucE], [Cd_IP])
GO
ALTER TABLE [dbo].[ImpComp] ADD CONSTRAINT [FK_ImpComp_TipDistrib] FOREIGN KEY ([Cd_TipDist]) REFERENCES [dbo].[TipDistrib] ([Cd_TipDist])
GO
