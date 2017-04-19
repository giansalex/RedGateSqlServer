SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Srv_TareaProgramadaParametro_Mdf] 
    @RucE nvarchar(11),
    @TareaProgramadaID char(10),
    @ReporteID char(10),
    @ReporteParametroID int,
    @ValorParametro nvarchar(100)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[TareaProgramadaParametro]
	SET    [RucE] = @RucE, [TareaProgramadaID] = @TareaProgramadaID, [ReporteID] = @ReporteID, [ReporteParametroID] = @ReporteParametroID, [ValorParametro] = @ValorParametro
	WHERE  [RucE] = @RucE
	       AND [TareaProgramadaID] = @TareaProgramadaID
	       AND [ReporteID] = @ReporteID
	       AND [ReporteParametroID] = @ReporteParametroID
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [TareaProgramadaID], [ReporteID], [ReporteParametroID], [ValorParametro]
	FROM   [dbo].[TareaProgramadaParametro]
	WHERE  [RucE] = @RucE
	       AND [TareaProgramadaID] = @TareaProgramadaID
	       AND [ReporteID] = @ReporteID
	       AND [ReporteParametroID] = @ReporteParametroID	
	-- End Return Select <- do not remove

	COMMIT

GO
