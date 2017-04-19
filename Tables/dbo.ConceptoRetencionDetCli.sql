CREATE TABLE [dbo].[ConceptoRetencionDetCli]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ConceptoRet] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ConceptoRetDetClt] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoRetencionDetCli] ADD CONSTRAINT [PK_ConceptoRetencionDetCli] PRIMARY KEY CLUSTERED  ([RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetClt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoRetencionDetCli] ADD CONSTRAINT [FK_ConceptoRetencionDetCli_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
ALTER TABLE [dbo].[ConceptoRetencionDetCli] ADD CONSTRAINT [FK_ConceptoRetencionDetCli_ConceptoRetencion] FOREIGN KEY ([RucE], [Cd_ConceptoRet]) REFERENCES [dbo].[ConceptoRetencion] ([RucE], [Cd_ConceptoRet])
GO
ALTER TABLE [dbo].[ConceptoRetencionDetCli] ADD CONSTRAINT [FK_ConceptoRetencionDetCli_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
