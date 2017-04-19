SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_CfgEmpresaGen_Mdf2] 
    @RucE nvarchar(11),
    @HabilitaReteciones bit,
    @PriorizaConcSunat bit,
    @HabilitaListaPrecio bit,
    @AmarraCltAVdr bit,
	@IB_MdfVta bit,
    @HabilitaSaldo bit,
    @Cd_MIS char(5)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE	[dbo].[CfgEmpresaGen]
	SET		[HabilitaReteciones] = @HabilitaReteciones, [PriorizaConcSunat] = @PriorizaConcSunat,
			[HabilitaListaPrecio] = @HabilitaListaPrecio, [AmarraCltAVdr] = @AmarraCltAVdr, [IB_MdfVta] = @IB_MdfVta, --PV
			[PtoVtaHabilitaSaldos] = @HabilitaSaldo, [PtoVta_Cd_MIS_Saldos] = @Cd_MIS
	WHERE	[RucE] = @RucE
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [HabilitaReteciones], [PriorizaConcSunat], [HabilitaListaPrecio],[AmarraCltAVdr],[IB_MdfVta],[PtoVtaHabilitaSaldos],[PtoVta_Cd_MIS_Saldos]
	FROM   [dbo].[CfgEmpresaGen]
	WHERE  [RucE] = @RucE	
	-- End Return Select <- do not remove

	COMMIT


--GC2016 PV: CREADO 05/05/2016
GO
