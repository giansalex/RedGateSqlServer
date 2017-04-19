SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Com_SolicitudReqDet2ConsxSR_Explo]
@RucE nvarchar(11),
@Cd_SR char(10),
@msj varchar(100) output
as
begin
select 	det.RucE,
	det.Cd_SR,	
	det.Item,
	det.Cd_Prod,
	det.Cd_Srv,
	isnull(srv.CodCo,prd.CodCo1_) as CodCo,
	isnull(prd.Nombre1,srv.Nombre) as Nombre,	
	det.Cant,
	det.Descrip,
	det.ID_UMP,
	pum.DescripAlt as DescripUMP,
	det.Obs,
	det.CA01,
	det.CA02,
	det.CA03,
	det.CA04,
	det.CA05
from SolicitudReqDet2 det
	Left join SolicitudReq2 sc on sc.RucE = det.RucE and sc.Cd_SR = det.Cd_SR
	Left join Producto2 prd on prd.RucE= det.RucE and prd.Cd_ProD= det.Cd_ProD
	Left join Prod_UM pum on pum.RucE = det.RucE and pum.ID_UMP = det.ID_UMP and pum.Cd_Prod=det.Cd_Prod
	left join Servicio2 srv on srv.RucE = det.RucE and srv.Cd_Srv = det.Cd_Srv
Where det.RucE=@RucE and det.Cd_SR=@Cd_SR
end
print @msj

GO
