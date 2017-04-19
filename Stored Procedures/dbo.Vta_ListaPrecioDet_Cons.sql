SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecioDet_Cons] 
    @RucE NVARCHAR(11),
    @Cd_LP CHAR(10),
    @Cd_Prod CHAR(7),
    @UMP INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [Cd_LP], [Cd_Prod], [UMP], [Desde], [Hasta], [Precio], [Cd_Mda], [Dscto1], [Dscto2], [Dscto3], [FechaInicio], [FechaFin], [EsPorcentaje] 
	FROM   [dbo].[ListaPrecioDet] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([Cd_LP] = @Cd_LP OR @Cd_LP IS NULL) 
	       AND ([Cd_Prod] = @Cd_Prod OR @Cd_Prod IS NULL) 
	       AND ([UMP] = @UMP OR @UMP IS NULL) 

	COMMIT

GO
