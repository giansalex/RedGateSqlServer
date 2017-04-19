SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetCli_Crea] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10),
    @Cd_ConceptoRetDetClt char(10) out,
    @Cd_Clt char(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	set @Cd_ConceptoRetDetClt = dbo.Cd_ConceptoRetDetClt(@RucE,@Cd_ConceptoRet)
	INSERT INTO [dbo].[ConceptoRetencionDetCli] ([RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetClt], [Cd_Clt])
	SELECT @RucE, @Cd_ConceptoRet, @Cd_ConceptoRetDetClt, @Cd_Clt
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetClt], [Cd_Clt]
	FROM   [dbo].[ConceptoRetencionDetCli]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetClt] = @Cd_ConceptoRetDetClt
	-- End Return Select <- do not remove
               
	COMMIT

GO
