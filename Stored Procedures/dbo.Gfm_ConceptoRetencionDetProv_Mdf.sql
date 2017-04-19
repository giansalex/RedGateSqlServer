SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetProv_Mdf] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10),
    @Cd_ConceptoRetDetProv char(10),
    @Cd_Prv char(7)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ConceptoRetencionDetProv]
	SET    [RucE] = @RucE, [Cd_ConceptoRet] = @Cd_ConceptoRet, [Cd_ConceptoRetDetProv] = @Cd_ConceptoRetDetProv, [Cd_Prv] = @Cd_Prv
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetProv] = @Cd_ConceptoRetDetProv
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetProv], [Cd_Prv]
	FROM   [dbo].[ConceptoRetencionDetProv]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetProv] = @Cd_ConceptoRetDetProv	
	-- End Return Select <- do not remove

	COMMIT

GO
