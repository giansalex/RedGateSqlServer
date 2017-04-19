SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ReporteParametros_Mdf] 
    @RucE nvarchar(11),
    @ReporteID char(10),
    @ReporteParametroID int,
    @NombreParametro varchar(50),
    @TipoParametro varchar(30),
    @DescripcionParametro varchar(150)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ReporteParametros]
	SET    [RucE] = @RucE, [ReporteID] = @ReporteID, [ReporteParametroID] = @ReporteParametroID, [NombreParametro] = @NombreParametro, [TipoParametro] = @TipoParametro, [DescripcionParametro] = @DescripcionParametro
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID
	       AND [ReporteParametroID] = @ReporteParametroID
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [ReporteID], [ReporteParametroID], [NombreParametro], [TipoParametro], [DescripcionParametro]
	FROM   [dbo].[ReporteParametros]
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID
	       AND [ReporteParametroID] = @ReporteParametroID	
	-- End Return Select <- do not remove

	COMMIT

GO
