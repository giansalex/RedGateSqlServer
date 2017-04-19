SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetProv_Cons] 
    @RucE NVARCHAR(11),
    @Cd_ConceptoRet CHAR(10),
    @Cd_ConceptoRetDetProv CHAR(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetProv], [Cd_Prv] 
	FROM   [dbo].[ConceptoRetencionDetProv] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([Cd_ConceptoRet] = @Cd_ConceptoRet OR @Cd_ConceptoRet IS NULL) 
	       AND ([Cd_ConceptoRetDetProv] = @Cd_ConceptoRetDetProv OR @Cd_ConceptoRetDetProv IS NULL) 

	COMMIT

GO
