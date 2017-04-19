SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencion_Elim] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ConceptoRetencion]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet

	COMMIT

GO
