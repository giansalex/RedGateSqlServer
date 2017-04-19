SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_Reportes_Crea] 
    @RucE nvarchar(11),
    @ReporteID char(10) out,
    @NombreReporte nvarchar(60),
    @DescripcionReporte nvarchar(150),
    @NombreConsulta nvarchar(150)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	Set @ReporteID = dbo.ReporteID(@RucE)
	INSERT INTO [dbo].[Reportes] ([RucE], [ReporteID], [NombreReporte], [DescripcionReporte], [NombreConsulta])
	SELECT @RucE, @ReporteID, @NombreReporte, @DescripcionReporte, @NombreConsulta
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [ReporteID], [NombreReporte], [DescripcionReporte], [NombreConsulta]
	FROM   [dbo].[Reportes]
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID
	-- End Return Select <- do not remove
               
	COMMIT

GO
