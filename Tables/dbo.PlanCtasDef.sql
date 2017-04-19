CREATE TABLE [dbo].[PlanCtasDef]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[IGV] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ISC] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[QCtg] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RCons] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Perc] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Det] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ret] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[LCm] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DC_MN] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DC_ME] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DP_MN] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DP_ME] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DCPer] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DCGan] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IN_DigCls] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL,
[CtaClt] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[CtaPrv] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[REjer] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PlanCtasDef] ADD CONSTRAINT [IX_PlanCtasDef_RUC_UNICO] UNIQUE NONCLUSTERED  ([RucE], [Ejer]) ON [PRIMARY]
GO
