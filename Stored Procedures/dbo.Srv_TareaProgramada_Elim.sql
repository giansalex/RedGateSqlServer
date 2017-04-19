SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Srv_TareaProgramada_Elim] 
    @RucE nvarchar(11),
    @TareaProgramadaID char(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[TareaProgramada]
	WHERE  [RucE] = @RucE
	       AND [TareaProgramadaID] = @TareaProgramadaID

	COMMIT

GO
