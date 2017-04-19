SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioSrvConsUnXSrv_paCot]
@RucE nvarchar(11),
@Cd_Cot char(10),
@ID_CtD int,
@msj varchar(100) output

as

Declare @ID_PrSv int
Declare @Cd_Srv char(7)

select @Cd_Srv=Cd_Srv,@ID_PrSv=ID_PrSv from CotizacionDet where RucE=@RucE and Cd_Cot=@Cd_Cot and ID_CtD = @ID_CtD


select 
	ID_PrSv,Cd_Srv,Cd_Mda,ValVta,IC_TipDscto,Dscto,IB_IncIGV,
	PVta,IC_TipVP,MrgInf,MrgSup
from PrecioSrv where RucE=@RucE  and Cd_Srv=@Cd_Srv and ID_PrSv=@ID_PrSv

-- LEYENDA --
-- DI : 08/04/2010 <Creacion del procedimiento almacenado>

GO
