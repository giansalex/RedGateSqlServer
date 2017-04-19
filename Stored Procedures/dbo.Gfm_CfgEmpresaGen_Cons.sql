SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_CfgEmpresaGen_Cons] 
    @RucE NVARCHAR(11),
    @HabilitaReteciones bit,
    @PriorizaConcSunat bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [RucE], [HabilitaReteciones], [PriorizaConcSunat], [HabilitaListaPrecio],[AmarraCltAVdr],[IB_MdfVta],[PtoVtaHabilitaSaldos],[PtoVta_Cd_MIS_Saldos],Cd_TDXDef_Clt,Cd_TDXDef_Vdr
	FROM   [dbo].[CfgEmpresaGen] 
	WHERE  ([RucE] = @RucE OR @RucE IS NULL) 
			And (HabilitaReteciones = @HabilitaReteciones OR @HabilitaReteciones is null)
			And (PriorizaConcSunat = @PriorizaConcSunat OR @PriorizaConcSunat IS NULL)

	COMMIT

--exec Gfm_CfgEmpresaGen_Cons '11111111111',null,null

GO
