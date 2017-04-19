SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_Reportes_Elim] 
    @RucE nvarchar(11),
    @ReporteID char(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Reportes]
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID

	COMMIT

GO
