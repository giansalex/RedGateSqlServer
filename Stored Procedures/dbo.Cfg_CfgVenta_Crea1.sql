SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[Cfg_CfgVenta_Crea1]
@RucE char(11)
      ,@IB_ValCltSNT bit
      ,@IB_NoPermRegCNV  bit
      ,@DE_IB_GenDE  bit
      ,@DE_IB_EnvSinc  bit 
      ,@DE_IB_GuardarArchs bit
      ,@DE_RutaArchs varchar(256)
      ,@DE_NroResol_SNT  varchar(50)
	  ,@DE_WS int
	  ,@msj varchar(100) output
	  as
begin

if not exists (select * from CfgVenta where RucE = @RucE )
	insert into CfgVenta(RucE ,IB_ValCltSNT, IB_NoPermRegCNV , DE_IB_GenDE , DE_IB_EnvSinc  , DE_IB_GuardarArchs , DE_RutaArchs , DE_NroResol_SNT,DE_CdWS )
	values (@RucE
      ,@IB_ValCltSNT
      ,@IB_NoPermRegCNV
      ,@DE_IB_GenDE
      ,@DE_IB_EnvSinc 
      ,@DE_IB_GuardarArchs
      ,@DE_RutaArchs
      ,@DE_NroResol_SNT
	  ,@DE_WS)	  
	else	
	begin
	update  CfgVenta set  RucE=@RucE
	,IB_ValCltSNT=@IB_ValCltSNT
	, IB_NoPermRegCNV=@IB_NoPermRegCNV
	, DE_IB_GenDE =@DE_IB_GenDE
	, DE_IB_EnvSinc =@DE_IB_EnvSinc
	, DE_IB_GuardarArchs= @DE_IB_GuardarArchs
	, DE_RutaArchs  =@DE_RutaArchs
	, DE_NroResol_SNT =@DE_NroResol_SNT
    , DE_CdWS = @DE_WS
   where RucE = @RucE
   	end

		if @@rowcount <=0
				set @msj = 'No se pudo ingresar el usuario'

end
--- gs - 2017-05-24  -- Add @DE_WS parameter
GO
