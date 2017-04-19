SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_CfgEmpresaGen_Mdf] 
    @RucE nvarchar(11),
    @HabilitaReteciones bit,
    @PriorizaConcSunat bit,
    @HabilitaListaPrecio bit,
    @AmarraCltVdr bit,
    @HabilitaSaldo bit,
    @Cd_MIS char(5)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[CfgEmpresaGen]
	SET    [RucE] = @RucE, [HabilitaReteciones] = @HabilitaReteciones, [PriorizaConcSunat] = @PriorizaConcSunat
			, [PtoVtaHabilitaSaldos] = @HabilitaSaldo, [PtoVta_Cd_MIS_Saldos] = @Cd_MIS
	WHERE  [RucE] = @RucE
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [HabilitaReteciones], [PriorizaConcSunat], [HabilitaListaPrecio],[AmarraCltAVdr],[PtoVtaHabilitaSaldos],[PtoVta_Cd_MIS_Saldos]
	FROM   [dbo].[CfgEmpresaGen]
	WHERE  [RucE] = @RucE	
	-- End Return Select <- do not remove

	COMMIT

GO
