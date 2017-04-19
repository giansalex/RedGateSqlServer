SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ColumnasReporte_Cons] 
    @RucE NVARCHAR(11),
    @ReporteID CHAR(10),
    @ColumnaReporteID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [ReporteID], [ColumnaReporteID], [NombreColumna], [ColorColumna], [ColorLetraColumna], [EnNegrita], [Derecha], [TextoColumna] 
	FROM   [dbo].[ColumnasReporte] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([ReporteID] = @ReporteID OR @ReporteID IS NULL) 
	       AND ([ColumnaReporteID] = @ColumnaReporteID OR @ColumnaReporteID IS NULL) 

	COMMIT

GO
