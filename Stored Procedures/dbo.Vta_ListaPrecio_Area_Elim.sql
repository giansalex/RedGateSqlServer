SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_Area_Elim] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @Cd_Area nvarchar(6)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ListaPrecio_Area]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Area] = @Cd_Area

	COMMIT

GO
