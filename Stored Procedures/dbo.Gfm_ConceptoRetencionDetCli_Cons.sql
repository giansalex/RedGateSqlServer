SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetCli_Cons] 
    @RucE NVARCHAR(11),
    @Cd_ConceptoRet CHAR(10),
    @Cd_ConceptoRetDetClt CHAR(10)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetClt], [Cd_Clt] 
	FROM   [dbo].[ConceptoRetencionDetCli] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
	       AND ([Cd_ConceptoRet] = @Cd_ConceptoRet OR @Cd_ConceptoRet IS NULL) 
	       AND ([Cd_ConceptoRetDetClt] = @Cd_ConceptoRetDetClt OR @Cd_ConceptoRetDetClt IS NULL) 

	COMMIT

GO
