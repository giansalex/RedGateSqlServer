CREATE TABLE [dbo].[ConceptoRetencionDetProd]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ConceptoRet] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ConceptoRetDetProd] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Porcentaje] [numeric] (4, 3) NULL,
[Monto] [numeric] (18, 7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoRetencionDetProd] ADD CONSTRAINT [PK_ConceptoRetencionDetProd] PRIMARY KEY CLUSTERED  ([RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetProd]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoRetencionDetProd] ADD CONSTRAINT [FK_ConceptoRetencionDetProd_ConceptoRetencion] FOREIGN KEY ([RucE], [Cd_ConceptoRet]) REFERENCES [dbo].[ConceptoRetencion] ([RucE], [Cd_ConceptoRet])
GO
ALTER TABLE [dbo].[ConceptoRetencionDetProd] ADD CONSTRAINT [FK_ConceptoRetencionDetProd_Producto] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
