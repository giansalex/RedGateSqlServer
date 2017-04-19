SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Cliente_Mdf] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @Cd_Clt char(10),
    @Estado bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ListaPrecio_Cliente]
	SET    [RucE] = @RucE, [Cd_LP] = @Cd_LP, [Cd_Clt] = @Cd_Clt, [Estado] = @Estado
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Clt] = @Cd_Clt
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_LP], [Cd_Clt], [Estado]
	FROM   [dbo].[ListaPrecio_Cliente]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Clt] = @Cd_Clt	
	-- End Return Select <- do not remove

	COMMIT

GO
