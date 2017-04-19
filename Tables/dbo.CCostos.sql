CREATE TABLE [dbo].[CCostos]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL,
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
ALTER TABLE [dbo].[CCostos] ADD CONSTRAINT [PK_CCostos] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CC]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CCostos] WITH NOCHECK ADD CONSTRAINT [FK_CCostos_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
