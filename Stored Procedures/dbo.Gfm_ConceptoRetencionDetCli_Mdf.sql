SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetCli_Mdf] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10),
    @Cd_ConceptoRetDetClt char(10),
    @Cd_Clt char(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ConceptoRetencionDetCli]
	SET    [RucE] = @RucE, [Cd_ConceptoRet] = @Cd_ConceptoRet, [Cd_ConceptoRetDetClt] = @Cd_ConceptoRetDetClt, [Cd_Clt] = @Cd_Clt
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetClt] = @Cd_ConceptoRetDetClt
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetClt], [Cd_Clt]
	FROM   [dbo].[ConceptoRetencionDetCli]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetClt] = @Cd_ConceptoRetDetClt	
	-- End Return Select <- do not remove

	COMMIT

GO
