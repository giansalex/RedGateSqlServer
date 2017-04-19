CREATE TABLE [dbo].[ConceptoRetencion]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_ConceptoRet] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NombreConcepto] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ModuloConcepto] [char] (1) COLLATE Modern_Spanish_CI_AS NOT NULL,
[AfectaClientes] [bit] NOT NULL,
[AfectaProveedores] [bit] NOT NULL,
[AfectaProductos] [bit] NOT NULL,
[AfectaServicios] [bit] NOT NULL,
[EsConceptoSunat] [bit] NOT NULL,
[TieneFechaVigencia] [bit] NOT NULL,
[FechaVigenciaInicio] [date] NULL,
[FechaVigenciaFin] [date] NULL,
[TieneMontoFijoRetencion] [bit] NOT NULL,
[MontoFijoRetencion] [numeric] (10, 7) NULL,
[PorcentajeRetencion] [numeric] (3, 2) NULL,
[MontoTotaMinimoConsiderar] [numeric] (13, 7) NULL,
[Estado] [bit] NOT NULL,
[Cd_MIS] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[TipComprobante] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[FechaPago] [int] NULL,
[FechaCobro] [int] NULL,
[EsDetraccion] [bit] NULL,
[EsPercepcion] [bit] NULL,
[Otros] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoRetencion] ADD CONSTRAINT [PK_ConceptoRetencion] PRIMARY KEY CLUSTERED  ([RucE], [Cd_ConceptoRet]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConceptoRetencion] ADD CONSTRAINT [FK_ConceptoRetencion_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[ConceptoRetencion] ADD CONSTRAINT [FK_ConceptoRetencion_MotivoIngresoSalida] FOREIGN KEY ([RucE], [Cd_MIS]) REFERENCES [dbo].[MtvoIngSal] ([RucE], [Cd_MIS])
GO
