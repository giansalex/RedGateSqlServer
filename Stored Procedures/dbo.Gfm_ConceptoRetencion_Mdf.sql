SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencion_Mdf] 
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

	UPDATE [dbo].[ConceptoRetencion]
	SET    [RucE] = @RucE, [Cd_ConceptoRet] = @Cd_ConceptoRet, [NombreConcepto] = @NombreConcepto, [ModuloConcepto] = @ModuloConcepto, [AfectaClientes] = @AfectaClientes, [AfectaProveedores] = @AfectaProveedores, [AfectaProductos] = @AfectaProductos, [AfectaServicios] = @AfectaServicios, [EsConceptoSunat] = @EsConceptoSunat, [TieneFechaVigencia] = @TieneFechaVigencia, [FechaVigenciaInicio] = @FechaVigenciaInicio, [FechaVigenciaFin] = @FechaVigenciaFin, [TieneMontoFijoRetencion] = @TieneMontoFijoRetencion, [MontoFijoRetencion] = @MontoFijoRetencion, [PorcentajeRetencion] = @PorcentajeRetencion, [MontoTotaMinimoConsiderar] = @MontoTotaMinimoConsiderar, [Estado] = @Estado, [Cd_MIS] = @Cd_MIS, [TipComprobante] = @TipComprobante, [FechaPago] = @FechaPago, [FechaCobro] = @FechaCobro
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_ConceptoRet], [NombreConcepto], [ModuloConcepto], [AfectaClientes], [AfectaProveedores], [AfectaProductos], [AfectaServicios], [EsConceptoSunat], [TieneFechaVigencia], [FechaVigenciaInicio], [FechaVigenciaFin], [TieneMontoFijoRetencion], [MontoFijoRetencion], [PorcentajeRetencion], [MontoTotaMinimoConsiderar], [Estado], [Cd_MIS], [TipComprobante], [FechaPago], [FechaCobro]
	FROM   [dbo].[ConceptoRetencion]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet	
	-- End Return Select <- do not remove

	COMMIT

GO
