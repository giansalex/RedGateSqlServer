CREATE TABLE [dbo].[CptoDetxProv]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CDtr] [char] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Ctb] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CptoDetxProv] ADD CONSTRAINT [FK_CptoDetxProv_ConceptosDetrac] FOREIGN KEY ([RucE], [Cd_CDtr]) REFERENCES [dbo].[ConceptosDetrac] ([RucE], [Cd_CDtr])
GO
ALTER TABLE [dbo].[CptoDetxProv] ADD CONSTRAINT [FK_CptoDetxProv_Proveedor2] FOREIGN KEY ([RucE], [Cd_Prv]) REFERENCES [dbo].[Proveedor2] ([RucE], [Cd_Prv])
GO
