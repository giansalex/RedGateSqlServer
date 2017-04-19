SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_MovimientoPtoVta_Elim] 
    @RucE nvarchar(11),
    @Cd_Vta nvarchar(10),
    @Cd_Mov char(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[MovimientoPtoVta]
	WHERE  [RucE] = @RucE
	       AND [Cd_Vta] = @Cd_Vta
	       AND [Cd_Mov] = @Cd_Mov

	COMMIT

GO
