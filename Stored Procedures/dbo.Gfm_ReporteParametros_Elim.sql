SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ReporteParametros_Elim] 
    @RucE nvarchar(11),
    @ReporteID char(10),
    @ReporteParametroID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ReporteParametros]
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID
	       AND [ReporteParametroID] = @ReporteParametroID

	COMMIT

GO
