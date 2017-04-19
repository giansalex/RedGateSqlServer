SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Elim] 
    @RucE nvarchar(11),
    @Cd_LP char(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ListaPrecio]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP

	COMMIT

GO
