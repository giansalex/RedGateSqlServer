SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ColumnasReporte_Elim] 
    @RucE nvarchar(11),
    @ReporteID char(10),
    @ColumnaReporteID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ColumnasReporte]
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID
	       AND [ColumnaReporteID] = @ColumnaReporteID

	COMMIT

GO
