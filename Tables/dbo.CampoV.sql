CREATE TABLE [dbo].[CampoV]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cp] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Valor] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CampoV] ADD CONSTRAINT [IX_CampoV] UNIQUE NONCLUSTERED  ([RucE], [Cd_Vta], [Cd_Cp]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CampoV] WITH NOCHECK ADD CONSTRAINT [FK_CampoV_Campo] FOREIGN KEY ([RucE], [Cd_Cp]) REFERENCES [dbo].[Campo] ([RucE], [Cd_Cp])
GO
