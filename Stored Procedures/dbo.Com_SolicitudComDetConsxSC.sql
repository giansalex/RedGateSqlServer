SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Com_SolicitudComDetConsxSC]
@RucE nvarchar(11),
@Cd_SC char(10),
@msj varchar(100) output
as
begin
select 	det.RucE,
	det.Cd_SC as CodSC,
	--sc.NroSC,
	det.Item as Itm,
	det.Cd_Prod as CodProd,
	isnull(prd.Nombre1,srv.Nombre) as NomProd,
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
from SolicitudComDet det
	Left join SolicitudCom sc on sc.RucE = det.RucE and sc.Cd_SC = det.Cd_SC
	Left join Producto2 prd on prd.RucE= det.RucE and prd.Cd_ProD= det.Cd_ProD
	Left join Prod_UM pum on pum.RucE = det.RucE and pum.ID_UMP = det.ID_UMP and pum.Cd_Prod=det.Cd_Prod
	left join Servicio2 srv on srv.RucE = det.RucE and srv.Cd_Srv = det.Cd_Srv
Where det.RucE=@RucE and det.Cd_SC=@Cd_SC
end
print @msj
-- Leyenda --
-- J : 2010-05-14 : <Creacion del procedimiento almacenado>
--exec Com_SolicitudComDetConsxSC '11111111111','SC00000001',null
--select * from SolicitudCom
GO
