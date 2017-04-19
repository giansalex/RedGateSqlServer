SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetProv_Crea] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10),
    @Cd_ConceptoRetDetProv char(10) out,
    @Cd_Prv char(7)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	Set @Cd_ConceptoRetDetProv = dbo.Cd_ConceptoRetDetProv(@RucE,@Cd_ConceptoRet)
	INSERT INTO [dbo].[ConceptoRetencionDetProv] ([RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetProv], [Cd_Prv])
	SELECT @RucE, @Cd_ConceptoRet, @Cd_ConceptoRetDetProv, @Cd_Prv
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetProv], [Cd_Prv]
	FROM   [dbo].[ConceptoRetencionDetProv]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetProv] = @Cd_ConceptoRetDetProv
	-- End Return Select <- do not remove
               
	COMMIT

GO
