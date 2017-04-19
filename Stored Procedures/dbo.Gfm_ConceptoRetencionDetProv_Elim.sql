SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetProv_Elim] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10),
    @Cd_ConceptoRetDetProv char(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[ConceptoRetencionDetProv]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetProv] = @Cd_ConceptoRetDetProv

	COMMIT

GO
