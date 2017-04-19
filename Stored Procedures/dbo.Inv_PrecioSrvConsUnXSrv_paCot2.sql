SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioSrvConsUnXSrv_paCot2]
@RucE nvarchar(11),
@Cd_Srv varchar(10),
@ID_PrSv int,
@msj varchar(100) output

as

select 
	ID_PrSv,Cd_Srv,Cd_Mda,ValVta,IC_TipDscto,Dscto,IB_IncIGV,
	PVta,IC_TipVP,MrgInf,MrgSup
from PrecioSrv where RucE=@RucE  and Cd_Srv=@Cd_Srv and ID_PrSv=@ID_PrSv

-- LEYENDA --
-- DI : 12/05/2011 <Creacion del procedimiento almacenado>


GO
