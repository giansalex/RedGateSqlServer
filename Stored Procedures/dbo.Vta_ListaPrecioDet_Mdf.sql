SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecioDet_Mdf] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @Cd_Prod char(7),
    @UMP int,
    @Desde numeric(13, 3),
    @Hasta numeric(13, 3),
    @Precio numeric(13, 2),
    @Cd_Mda nvarchar(2),
    @Dscto1 decimal(5, 4),
    @Dscto2 decimal(5, 4),
    @Dscto3 decimal(5, 4),
    @FechaInicio smalldatetime,
    @FechaFin smalldatetime,
    @EsPorcentaje bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ListaPrecioDet]
	SET    [RucE] = @RucE, [Cd_LP] = @Cd_LP, [Cd_Prod] = @Cd_Prod, [UMP] = @UMP, [Desde] = @Desde, [Hasta] = @Hasta, [Precio] = @Precio, [Cd_Mda] = @Cd_Mda, [Dscto1] = @Dscto1, [Dscto2] = @Dscto2, [Dscto3] = @Dscto3, [FechaInicio] = @FechaInicio, [FechaFin] = @FechaFin, [EsPorcentaje] = @EsPorcentaje
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Prod] = @Cd_Prod
	       AND [UMP] = @UMP
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_LP], [Cd_Prod], [UMP], [Desde], [Hasta], [Precio], [Cd_Mda], [Dscto1], [Dscto2], [Dscto3], [FechaInicio], [FechaFin], [EsPorcentaje]
	FROM   [dbo].[ListaPrecioDet]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Prod] = @Cd_Prod
	       AND [UMP] = @UMP	
	-- End Return Select <- do not remove

	COMMIT

GO
