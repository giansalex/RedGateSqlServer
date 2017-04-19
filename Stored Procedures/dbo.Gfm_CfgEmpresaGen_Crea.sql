SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Gfm_CfgEmpresaGen_Crea] 
    @RucE nvarchar(11),
    @HabilitaReteciones bit,
    @PriorizaConcSunat bit,
    @HabilitaListaPrecio bit,
    @AmarraCltVdr bit,
    @PtoVtaHabilitaSaldos bit,
    @PtoVta_Cd_MIS_Saldos char(3),
    @Cd_TDXDef_Clt nvarchar(2),
    @Cd_TDXDef_Vdr nvarchar(2)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[CfgEmpresaGen] ([RucE], [HabilitaReteciones], [PriorizaConcSunat],[HabilitaListaPrecio],[AmarraCltAVdr],[PtoVtaHabilitaSaldos],[PtoVta_Cd_MIS_Saldos],[Cd_TDXDef_Clt],[Cd_TDXDef_Vdr])
	SELECT @RucE, @HabilitaReteciones, @PriorizaConcSunat, @HabilitaListaPrecio, @AmarraCltVdr, @PtoVtaHabilitaSaldos,@PtoVta_Cd_MIS_Saldos,@Cd_TDXDef_Clt,@Cd_TDXDef_Vdr
	
	-- Begin Return Select <- do not remove
	SELECT [RucE], [HabilitaReteciones], [PriorizaConcSunat][HabilitaListaPrecio],[AmarraCltAVdr]
	FROM   [dbo].[CfgEmpresaGen]
	WHERE  [RucE] = @RucE
	-- End Return Select <- do not remove
               
	COMMIT

GO
