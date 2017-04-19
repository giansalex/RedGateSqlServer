SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Srv_TareaProgramadaParametro_Crea] 
    @RucE nvarchar(11),
    @TareaProgramadaID char(10),
    @ReporteID char(10),
    @ReporteParametroID int,
    @ValorParametro nvarchar(100)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[TareaProgramadaParametro] ([RucE], [TareaProgramadaID], [ReporteID], [ReporteParametroID], [ValorParametro])
	SELECT @RucE, @TareaProgramadaID, @ReporteID, @ReporteParametroID, @ValorParametro
	
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
