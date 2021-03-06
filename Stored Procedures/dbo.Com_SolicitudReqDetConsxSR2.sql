SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Com_SolicitudReqDetConsxSR2]
@RucE nvarchar(11),
@Cd_SR char(10),
@msj varchar(100) output
as
begin
select 	det.RucE,
	det.Cd_SR as CodSR,	
	det.Item as Itm,
	det.Cd_Prod as CodProd,
	det.Cd_Srv,
	isnull(prd.Nombre1,srv.Nombre) as Nombre,	
	det.Cant,
	det.Descrip,
	det.ID_UMP as UMP,
	pum.DescripAlt as DescripUMP,
	det.Obs,
	det.CA01,
	det.CA02,
	det.CA03,
	det.CA04,
	det.CA05
from SolicitudReqDet det
	Left join SolicitudReq sc on sc.RucE = det.RucE and sc.Cd_SR = det.Cd_SR
	Left join Producto2 prd on prd.RucE= det.RucE and prd.Cd_ProD= det.Cd_ProD
	Left join Prod_UM pum on pum.RucE = det.RucE and pum.ID_UMP = det.ID_UMP and pum.Cd_Prod=det.Cd_Prod
	left join Servicio2 srv on srv.RucE = det.RucE and srv.Cd_Srv = det.Cd_Srv
Where det.RucE=@RucE and det.Cd_SR=@Cd_SR
end
print @msj
--	LEYENDA
/*	MM : <06/08/11 : Creacion del SP>
	
*/
--	PRUEBAS
/*	exec Com_SolicitudReqDetConsxSR2 '11111111111','SR00000070',null
	
*/
GO
