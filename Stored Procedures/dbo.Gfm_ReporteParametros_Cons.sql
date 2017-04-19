SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ReporteParametros_Cons] 
    @RucE NVARCHAR(11),
    @ReporteID CHAR(10),
    @ReporteParametroID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [ReporteID], [ReporteParametroID], [NombreParametro], [TipoParametro], [DescripcionParametro] 
	FROM   [dbo].[ReporteParametros] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([ReporteID] = @ReporteID OR @ReporteID IS NULL) 
	       AND ([ReporteParametroID] = @ReporteParametroID OR @ReporteParametroID IS NULL) 

	COMMIT

GO
