SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ReporteParametros_Crea] 
    @RucE nvarchar(11),
    @ReporteID char(10),
    @NombreParametro varchar(50),
    @TipoParametro varchar(30),
    @DescripcionParametro varchar(150)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	declare @ReporteParametroID int
	set @ReporteParametroID = dbo.ReporteParametroID(@RucE,@ReporteID) 
	INSERT INTO [dbo].[ReporteParametros] ([RucE], [ReporteID], [ReporteParametroID], [NombreParametro], [TipoParametro], [DescripcionParametro])
	SELECT @RucE, @ReporteID, @ReporteParametroID, @NombreParametro, @TipoParametro, @DescripcionParametro
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [ReporteID], [ReporteParametroID], [NombreParametro], [TipoParametro], [DescripcionParametro]
	FROM   [dbo].[ReporteParametros]
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID
	       AND [ReporteParametroID] = @ReporteParametroID
	-- End Return Select <- do not remove
               
	COMMIT

GO
