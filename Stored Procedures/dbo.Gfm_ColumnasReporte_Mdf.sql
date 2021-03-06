SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ColumnasReporte_Mdf] 
    @RucE nvarchar(11),
    @ReporteID char(10),
    @ColumnaReporteID int,
    @NombreColumna nvarchar(45),
    @ColorColumna nvarchar(9),
    @ColorLetraColumna nvarchar(9),
    @EnNegrita bit,
    @Derecha bit,
    @TextoColumna nvarchar(70)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ColumnasReporte]
	SET    [RucE] = @RucE, [ReporteID] = @ReporteID, [ColumnaReporteID] = @ColumnaReporteID, [NombreColumna] = @NombreColumna, [ColorColumna] = @ColorColumna, [ColorLetraColumna] = @ColorLetraColumna, [EnNegrita] = @EnNegrita, [Derecha] = @Derecha, [TextoColumna] = @TextoColumna
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID
	       AND [ColumnaReporteID] = @ColumnaReporteID
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [ReporteID], [ColumnaReporteID], [NombreColumna], [ColorColumna], [ColorLetraColumna], [EnNegrita], [Derecha], [TextoColumna]
	FROM   [dbo].[ColumnasReporte]
	WHERE  [RucE] = @RucE
	       AND [ReporteID] = @ReporteID
	       AND [ColumnaReporteID] = @ColumnaReporteID	
	-- End Return Select <- do not remove

	COMMIT

GO
