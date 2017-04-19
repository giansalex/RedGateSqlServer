CREATE TABLE [dbo].[AmarreRpt]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroCta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Rb] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AmarreRpt] WITH NOCHECK ADD CONSTRAINT [FK_ReporteEF_RubrosEF] FOREIGN KEY ([Cd_Rb]) REFERENCES [dbo].[RubrosRpt] ([Cd_Rb])
GO
