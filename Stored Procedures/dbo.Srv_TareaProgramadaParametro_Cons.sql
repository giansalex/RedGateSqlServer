SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Srv_TareaProgramadaParametro_Cons] 
    @RucE NVARCHAR(11),
    @TareaProgramadaID CHAR(10),
    @ReporteID CHAR(10),
    @ReporteParametroID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [TareaProgramadaID], [ReporteID], [ReporteParametroID], [ValorParametro] 
	FROM   [dbo].[TareaProgramadaParametro] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([TareaProgramadaID] = @TareaProgramadaID OR @TareaProgramadaID IS NULL) 
	       AND ([ReporteID] = @ReporteID OR @ReporteID IS NULL) 
	       AND ([ReporteParametroID] = @ReporteParametroID OR @ReporteParametroID IS NULL) 

	COMMIT

GO
