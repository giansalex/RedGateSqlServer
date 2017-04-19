SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ConceptoRetencionDetServ_Crea] 
    @RucE nvarchar(11),
    @Cd_ConceptoRet char(10),
    @Cd_ConceptoRetDetServ char(10) out,
    @Cd_Srv char(7),
    @Porcentaje numeric(4, 3),
    @Monto numeric(18, 7)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	Set @Cd_ConceptoRetDetServ = dbo.Cd_ConceptoRetDetServ(@RucE,@Cd_ConceptoRet)
	INSERT INTO [dbo].[ConceptoRetencionDetServ] ([RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetServ], [Cd_Srv], [Porcentaje], [Monto])
	SELECT @RucE, @Cd_ConceptoRet, @Cd_ConceptoRetDetServ, @Cd_Srv, @Porcentaje, @Monto
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [Cd_ConceptoRet], [Cd_ConceptoRetDetServ], [Cd_Srv], [Porcentaje], [Monto]
	FROM   [dbo].[ConceptoRetencionDetServ]
	WHERE  [RucE] = @RucE
	       AND [Cd_ConceptoRet] = @Cd_ConceptoRet
	       AND [Cd_ConceptoRetDetServ] = @Cd_ConceptoRetDetServ
	-- End Return Select <- do not remove
               
	COMMIT

GO
