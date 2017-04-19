SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetProd_Mdf] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10),
    @Cd_ConceptoRetDetProd char(10),
    @Cd_Prod char(7),
    @Porcentaje numeric(4, 3),
    @Monto numeric(18, 7)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ConceptoRetencionDetProd]
	SET    [RucE] = @RucE, [Cd_ConceptoRet] = @Cd_ConceptoRet, [Cd_ConceptoRetDetProd] = @Cd_ConceptoRetDetProd, [Cd_Prod] = @Cd_Prod, [Porcentaje] = @Porcentaje, [Monto] = @Monto
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetProd] = @Cd_ConceptoRetDetProd
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetProd], [Cd_Prod], [Porcentaje], [Monto]
	FROM   [dbo].[ConceptoRetencionDetProd]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetProd] = @Cd_ConceptoRetDetProd	
	-- End Return Select <- do not remove

	COMMIT

GO
