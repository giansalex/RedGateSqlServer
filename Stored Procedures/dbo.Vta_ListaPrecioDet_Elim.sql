SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecioDet_Elim] 
    @RucE nvarchar(11),
    @Cd_LP char(10),
    @Cd_Prod char(7),
    @UMP int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ListaPrecioDet]
	WHERE  [RucE] = @RucE
	       AND [Cd_LP] = @Cd_LP
	       AND [Cd_Prod] = @Cd_Prod
	       AND [UMP] = @UMP

	COMMIT

GO
