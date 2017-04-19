SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencion_Cons] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10),
    @NombreConcepto varchar(50),
    @ModuloConcepto char(1),
    @AfectaClientes bit,
    @AfectaProveedores bit,
    @AfectaProductos bit,
    @AfectaServicios bit,
    @EsConceptoSunat bit,
    @TieneFechaVigencia bit,
    @FechaVigenciaInicio date,
    @FechaVigenciaFin date,
    @TieneMontoFijoRetencion bit,
    @MontoFijoRetencion numeric(10, 7),
    @PorcentajeRetencion numeric(3, 2),
    @MontoTotaMinimoConsiderar numeric(13, 7),
    @Estado bit,
    @Cd_MIS char(3),
    @TipComprobante char(2),
    @FechaPago int,
    @FechaCobro int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT *
	FROM   [dbo].[ConceptoRetencion] 
	WHERE  RucE = @RucE 
	       AND (@Cd_ConceptoRet IS NULL OR[Cd_ConceptoRet] = @Cd_ConceptoRet) 
	       AND (@NombreConcepto IS NULL OR NombreConcepto = @NombreConcepto)
	       AND (@ModuloConcepto IS NULL OR ModuloConcepto = @ModuloConcepto)
	       AND (@AfectaClientes IS NULL OR AfectaClientes = @AfectaClientes)
	       AND (@AfectaServicios IS NULL OR AfectaServicios = @AfectaServicios)
	       AND (AfectaProveedores = @AfectaProveedores OR @AfectaProveedores IS NULL)
	       AND (AfectaProductos = @AfectaProductos OR @AfectaProductos IS NULL)
	       AND (EsConceptoSunat = @EsConceptoSunat OR @EsConceptoSunat IS NULL)
	       AND (TieneFechaVigencia = @TieneFechaVigencia OR @TieneFechaVigencia IS NULL)
	       AND (FechaVigenciaInicio = @FechaVigenciaInicio OR @FechaVigenciaInicio IS NULL)
	       AND (FechaVigenciaFin = @FechaVigenciaFin OR @FechaVigenciaFin IS NULL)
	       AND (TieneMontoFijoRetencion = @TieneMontoFijoRetencion OR @TieneMontoFijoRetencion IS NULL)
	       AND (MontoFijoRetencion = @MontoFijoRetencion OR @MontoFijoRetencion IS NULL)
	       AND (PorcentajeRetencion =@PorcentajeRetencion OR @PorcentajeRetencion IS NULL)
	       AND (MontoTotaMinimoConsiderar = @MontoTotaMinimoConsiderar OR @MontoTotaMinimoConsiderar IS NULL)
	       AND (Estado = @Estado OR @Estado IS NULL)
		   AND (Cd_MIS = @Cd_MIS OR @Cd_MIS IS NULL)
		   AND (TipComprobante = @TipComprobante OR @TipComprobante IS NULL)
		   AND (FechaPago = @FechaPago OR @FechaPago IS NULL)
		   AND (FechaCobro = @FechaCobro OR @FechaCobro IS NULL)
	COMMIT

GO
