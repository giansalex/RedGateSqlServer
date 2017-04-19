SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetProd_Elim] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10),
    @Cd_ConceptoRetDetProd char(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ConceptoRetencionDetProd]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetProd] = @Cd_ConceptoRetDetProd

	COMMIT

GO
