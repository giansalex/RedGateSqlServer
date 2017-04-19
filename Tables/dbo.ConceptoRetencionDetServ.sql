CREATE TABLE [dbo].[ConceptoRetencionDetServ]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ConceptoRet] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ConceptoRetDetServ] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Porcentaje] [numeric] (4, 3) NULL,
[Monto] [numeric] (18, 7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoRetencionDetServ] ADD CONSTRAINT [PK_ConceptoRetencionDetServ] PRIMARY KEY CLUSTERED  ([RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetServ]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoRetencionDetServ] ADD CONSTRAINT [FK_ConceptoRetencionDetServ_ConceptoRetencion] FOREIGN KEY ([RucE], [Cd_ConceptoRet]) REFERENCES [dbo].[ConceptoRetencion] ([RucE], [Cd_ConceptoRet])
GO
ALTER TABLE [dbo].[ConceptoRetencionDetServ] ADD CONSTRAINT [FK_ConceptoRetencionDetServ_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[ConceptoRetencionDetServ] ADD CONSTRAINT [FK_ConceptoRetencionDetServ_Servicio] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
