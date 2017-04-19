SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Vendedores_Crea] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @Cd_Vdr char(7),
    @Estado bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[ListaPrecio_Vendedores] ([RucE], [Cd_LP], [Cd_Vdr], [Estado])
	SELECT @RucE, @Cd_LP, @Cd_Vdr, @Estado
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_LP], [Cd_Vdr], [Estado]
	FROM   [dbo].[ListaPrecio_Vendedores]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Vdr] = @Cd_Vdr
	-- End Return Select <- do not remove
               
	COMMIT

GO
