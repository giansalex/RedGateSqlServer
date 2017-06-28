SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Cfg_CfgVenta_ConsUn]
@RucE char(11)
,@msj varchar(100) output
as
begin

if not exists (select * from CfgVenta where RucE = @RucE )
BEGIN
		set @msj = 'No existe  configuración de la venta.'
		RETURN
END
		
SELECT RucE 
      ,IB_ValCltSNT
      ,IB_NoPermRegCNV
      ,DE_IB_GenDE
      ,DE_IB_EnvSinc
      ,DE_IB_GuardarArchs
      ,DE_RutaArchs
      ,DE_NroResol_SNT
	  ,DE_CdWS
  FROM CfgVenta
 where RucE = @RucE

end
GO
