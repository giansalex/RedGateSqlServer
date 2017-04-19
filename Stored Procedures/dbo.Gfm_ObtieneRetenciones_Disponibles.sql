SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Gfm_ObtieneRetenciones_Disponibles]
@RucE nvarchar(11),
@Modulo char(1),
@Cd_Clt varchar(10),
@Fecha date
As
Select 
			Cr.RucE,
			Cr.Cd_ConceptoRet,
			Cr.NombreConcepto,
			Cr.ModuloConcepto,
			Cr.AfectaClientes,
			Cr.AfectaProveedores,
			Cr.AfectaProductos,
			Cr.AfectaServicios,
			Cr.EsConceptoSunat,
			Cr.TieneFechaVigencia,
			Cr.FechaVigenciaInicio,
			Cr.FechaVigenciaFin,
			Cr.TieneMontoFijoRetencion,
			Cr.MontoFijoRetencion,
			Cr.PorcentajeRetencion,
			Cr.MontoTotaMinimoConsiderar,
			Cr.Estado,
			Cr.Cd_MIS,
			Cr.TipComprobante,
			Cr.FechaPago,
			Cr.FechaCobro,
			Cr.EsDetraccion,
			Cr.EsPercepcion,
			Cr.Otros
From 
			ConceptoRetencion As Cr 
Inner Join
			ConceptoRetencionDetCli As CrC
On
			Cr.RucE = CrC.RucE And
			Cr.Cd_ConceptoRet = CrC.Cd_ConceptoRet
Where 
			Cr.RucE = @RucE And
			Cr.Estado = 1 And
			CrC.Cd_Clt = @Cd_Clt And
			Cr.TieneFechaVigencia = 0 And
			Cr.FechaVigenciaInicio IS Null
Group By
			Cr.RucE,
			Cr.Cd_ConceptoRet,
			Cr.NombreConcepto,
			Cr.ModuloConcepto,
			Cr.AfectaClientes,
			Cr.AfectaProveedores,
			Cr.AfectaProductos,
			Cr.AfectaServicios,
			Cr.EsConceptoSunat,
			Cr.TieneFechaVigencia,
			Cr.FechaVigenciaInicio,
			Cr.FechaVigenciaFin,
			Cr.TieneMontoFijoRetencion,
			Cr.MontoFijoRetencion,
			Cr.PorcentajeRetencion,
			Cr.MontoTotaMinimoConsiderar,
			Cr.Estado,
			Cr.Cd_MIS,
			Cr.TipComprobante,
			Cr.FechaPago,
			Cr.FechaCobro,
			Cr.EsDetraccion,
			Cr.EsPercepcion,
			Cr.Otros

union

Select 
			Cr.RucE,
			Cr.Cd_ConceptoRet,
			Cr.NombreConcepto,
			Cr.ModuloConcepto,
			Cr.AfectaClientes,
			Cr.AfectaProveedores,
			Cr.AfectaProductos,
			Cr.AfectaServicios,
			Cr.EsConceptoSunat,
			Cr.TieneFechaVigencia,
			Cr.FechaVigenciaInicio,
			Cr.FechaVigenciaFin,
			Cr.TieneMontoFijoRetencion,
			Cr.MontoFijoRetencion,
			Cr.PorcentajeRetencion,
			Cr.MontoTotaMinimoConsiderar,
			Cr.Estado,
			Cr.Cd_MIS,
			Cr.TipComprobante,
			Cr.FechaPago,
			Cr.FechaCobro,
			Cr.EsDetraccion,
			Cr.EsPercepcion,
			Cr.Otros
From 
			ConceptoRetencion As Cr 
Inner Join
			ConceptoRetencionDetCli As CrC
On
			Cr.RucE = CrC.RucE And
			Cr.Cd_ConceptoRet = CrC.Cd_ConceptoRet
Where 
			Cr.RucE = @RucE And
			Cr.Estado = 1 And
			CrC.Cd_Clt = @Cd_Clt And
			Cr.TieneFechaVigencia = 1 And
			@Fecha between Cr.FechaVigenciaInicio And Cr.FechaVigenciaFin
			
Group By
			Cr.RucE,
			Cr.Cd_ConceptoRet,
			Cr.NombreConcepto,
			Cr.ModuloConcepto,
			Cr.AfectaClientes,
			Cr.AfectaProveedores,
			Cr.AfectaProductos,
			Cr.AfectaServicios,
			Cr.EsConceptoSunat,
			Cr.TieneFechaVigencia,
			Cr.FechaVigenciaInicio,
			Cr.FechaVigenciaFin,
			Cr.TieneMontoFijoRetencion,
			Cr.MontoFijoRetencion,
			Cr.PorcentajeRetencion,
			Cr.MontoTotaMinimoConsiderar,
			Cr.Estado,
			Cr.Cd_MIS,
			Cr.TipComprobante,
			Cr.FechaPago,
			Cr.FechaCobro,
			Cr.EsDetraccion,
			Cr.EsPercepcion,
			Cr.Otros
GO
