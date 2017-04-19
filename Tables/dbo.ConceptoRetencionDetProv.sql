CREATE TABLE [dbo].[ConceptoRetencionDetProv]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ConceptoRet] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ConceptoRetDetProv] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoRetencionDetProv] ADD CONSTRAINT [PK_ConceptoRetencionDetProv] PRIMARY KEY CLUSTERED  ([RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetProv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoRetencionDetProv] ADD CONSTRAINT [FK_ConceptoRetencionDetProv_ConceptoRetencion] FOREIGN KEY ([RucE], [Cd_ConceptoRet]) REFERENCES [dbo].[ConceptoRetencion] ([RucE], [Cd_ConceptoRet])
GO
ALTER TABLE [dbo].[ConceptoRetencionDetProv] ADD CONSTRAINT [FK_ConceptoRetencionDetProv_Proveedor2] FOREIGN KEY ([RucE], [Cd_Prv]) REFERENCES [dbo].[Proveedor2] ([RucE], [Cd_Prv])
GO
