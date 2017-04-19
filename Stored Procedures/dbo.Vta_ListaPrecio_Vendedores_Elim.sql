SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Vendedores_Elim] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @Cd_Vdr char(7)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	IF @Cd_LP IS NULL 



	DELETE
	FROM   [dbo].[ListaPrecio_Vendedores]
	WHERE  [RucE] = @RucE	     
	       AND [Cd_Vdr] = @Cd_Vdr
		  


	ELSE

	BEGIN
	BEGIN TRAN
	DELETE
	FROM   [dbo].[ListaPrecio_Vendedores]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Vdr] = @Cd_Vdr

	COMMIT
	END
GO
