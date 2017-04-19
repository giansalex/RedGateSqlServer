SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_Reportes_Cons] 
    @RucE NVARCHAR(11),
    @ReporteID CHAR(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [ReporteID], [NombreReporte], [DescripcionReporte], [NombreConsulta] 
	FROM   [dbo].[Reportes] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([ReporteID] = @ReporteID OR @ReporteID IS NULL) 

	COMMIT

GO
