SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Com_SolicitudComDetConsxSC_Web]
@RucE nvarchar(11),
@Cd_SC char(10),
@Cd_SCoEnv int,
@msj varchar(100) output
as
begin
select 	det.RucE,
	det.Cd_SC as CodSC,
	--sc.NroSC,
	det.Item as Itm,
	det.Cd_Prod as CodProd,
	det.Cd_SRV as CodSrv,
	isnull(prd.Nombre1,srv.Nombre) as NomProd,
	sd.Cant,sd.Precio as Valor,
	det.Descrip,
	isnull(det.ID_UMP,'-') as UMP,
	pum.DescripAlt as DescripUMP,
	det.Obs,
	det.CA01,
	det.CA02,
	det.CA03,
	det.CA04,
	det.CA05
from SolicitudComDet det
	Left join SolicitudCom sc on sc.RucE = det.RucE and sc.Cd_SC = det.Cd_SC
	Left join Producto2 prd on prd.RucE= det.RucE and prd.Cd_ProD= det.Cd_ProD
	Left join Prod_UM pum on pum.RucE = det.RucE and pum.ID_UMP = det.ID_UMP and pum.Cd_Prod=det.Cd_Prod
	left join Servicio2 srv on srv.RucE = det.RucE and srv.Cd_Srv = det.Cd_Srv
	left join SCxProv sp on sp.RucE = det.RucE and sp.Cd_SCo = det.Cd_SC
	left join SCxProvDet sd on sd.RucE=sp.RucE and sd.Cd_SCoEnv=sp.Cd_SCoEnv and sd.Cd_Prod = prd.Cd_Prod
Where det.RucE=@RucE and det.Cd_SC=@Cd_SC and sp.Cd_SCoEnv = @Cd_SCoEnv and sd.IB_Acp = 1
end
print @msj
-- Leyenda --
-- cam : 19/06/2012 : <Creacion del procedimiento almacenado>
-- exec Com_SolicitudComDetConsxSC_web '11111111111','SC00000243','87',null
-- select * from SolicitudCom
/*
exec Com_SolicitudComDetConsxSC_web '11111111111','SC00000243','86',null
exec Com_SolicitudComDetConsxSC_web '11111111111','SC00000243','87',null
*/
GO
