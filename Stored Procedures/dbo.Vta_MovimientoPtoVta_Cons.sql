SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_MovimientoPtoVta_Cons] 
    @RucE NVARCHAR(11),
    @Cd_Vta NVARCHAR(10),
    @Cd_Mov CHAR(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [Cd_Vta], [Cd_Mov], [MontoAPagar], [MontoPagado], [Saldo], [SaldoAcumulado], [FechaMovimiento] 
	FROM   [dbo].[MovimientoPtoVta] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([Cd_Vta] = @Cd_Vta OR @Cd_Vta IS NULL) 
	       AND ([Cd_Mov] = @Cd_Mov OR @Cd_Mov IS NULL) 

	COMMIT

GO
