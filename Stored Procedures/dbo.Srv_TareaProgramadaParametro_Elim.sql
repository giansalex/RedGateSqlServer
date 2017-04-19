SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Srv_TareaProgramadaParametro_Elim] 
    @RucE nvarchar(11),
    @TareaProgramadaID char(10),
    @ReporteID char(10),
    @ReporteParametroID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[TareaProgramadaParametro]
	WHERE  [RucE] = @RucE
	       AND [TareaProgramadaID] = @TareaProgramadaID
	       AND [ReporteID] = @ReporteID
	       AND [ReporteParametroID] = @ReporteParametroID

	COMMIT

GO
