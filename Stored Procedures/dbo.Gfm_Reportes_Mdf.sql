SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_Reportes_Mdf] 
    @RucE nvarchar(11),
    @ReporteID char(10),
    @NombreReporte nvarchar(60),
    @DescripcionReporte nvarchar(150),
    @NombreConsulta nvarchar(150)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Reportes]
	SET    [RucE] = @RucE, [ReporteID] = @ReporteID, [NombreReporte] = @NombreReporte, [DescripcionReporte] = @DescripcionReporte, [NombreConsulta] = @NombreConsulta
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [ReporteID], [NombreReporte], [DescripcionReporte], [NombreConsulta]
	FROM   [dbo].[Reportes]
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID	
	-- End Return Select <- do not remove

	COMMIT

GO
