SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetServ_Mdf] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10),
    @Cd_ConceptoRetDetServ char(10),
    @Cd_Srv char(7),
    @Porcentaje numeric(4, 3),
    @Monto numeric(18, 7)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[ConceptoRetencionDetServ]
	SET    [RucE] = @RucE, [Cd_ConceptoRet] = @Cd_ConceptoRet, [Cd_ConceptoRetDetServ] = @Cd_ConceptoRetDetServ, [Cd_Srv] = @Cd_Srv, [Porcentaje] = @Porcentaje, [Monto] = @Monto
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetServ] = @Cd_ConceptoRetDetServ
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetServ], [Cd_Srv], [Porcentaje], [Monto]
	FROM   [dbo].[ConceptoRetencionDetServ]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetServ] = @Cd_ConceptoRetDetServ	
	-- End Return Select <- do not remove

	COMMIT

GO
