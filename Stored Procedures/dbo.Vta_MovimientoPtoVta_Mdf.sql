SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_MovimientoPtoVta_Mdf] 
    @RucE nvarchar(11),
    @Cd_Vta nvarchar(10),
    @Cd_Mov char(10),
    @MontoAPagar decimal(20, 7),
    @MontoPagado decimal(20, 7),
    @Saldo decimal(18, 7),
    @SaldoAcumulado decimal(18, 7),
    @FechaMovimiento datetime
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[MovimientoPtoVta]
	SET    [RucE] = @RucE, [Cd_Vta] = @Cd_Vta, [Cd_Mov] = @Cd_Mov, [MontoAPagar] = @MontoAPagar, [MontoPagado] = @MontoPagado, [Saldo] = @Saldo, [SaldoAcumulado] = @SaldoAcumulado, [FechaMovimiento] = @FechaMovimiento
	WHERE  [RucE] = @RucE
	       AND [Cd_Vta] = @Cd_Vta
	       AND [Cd_Mov] = @Cd_Mov
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_Vta], [Cd_Mov], [MontoAPagar], [MontoPagado], [Saldo], [SaldoAcumulado], [FechaMovimiento]
	FROM   [dbo].[MovimientoPtoVta]
	WHERE  [RucE] = @RucE
	       AND [Cd_Vta] = @Cd_Vta
	       AND [Cd_Mov] = @Cd_Mov	
	-- End Return Select <- do not remove

	COMMIT

GO
