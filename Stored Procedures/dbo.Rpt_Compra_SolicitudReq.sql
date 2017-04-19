SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_Compra_SolicitudReq]
---------------------------------------------------------------------------------
/*------VARIABLES DEL PROCEDIMIENTO ALMACENADO-------*/
---------------------------------------------------------------------------------
@RucE nvarchar(11),
@Cd_SR nvarchar(10),
@msj varchar(100) output
as

/*Declare @RucE nvarchar(11)
set @RucE = '11111111111'

Declare @Cd_SR nvarchar(10)
set @Cd_SR = 'SR00000013'*/

---------------------------------------------------------------------------------
/*------INFORMACION DE LA EMPRESA-------*/
---------------------------------------------------------------------------------
--select * from Empresa WHERE Ruc=@RucE
---------------------------------------------------------------------------------
/*------INFORMACION DE LA SOLICITUD DE REQUERIMIENTO-------*/
---------------------------------------------------------------------------------

SET CONCAT_NULL_YIELDS_NULL OFF

select 
sr.RucE,e.RSocial,e.Direccion,--,isnull(e.Logo,'') as Logo,
sr.Cd_SR,sr.NroSR,convert(varchar,sr.FecEmi,103) as FecEmi ,
convert(varchar,sr.FecEntR,103) as FecEntR,sr.Asunto,
sr.Cd_Area,a.Descrip as DescripArea,a.NCorto as NCortoArea,
sr.Obs,sr.ElaboradoPor,sr.AutorizadoPor,
convert(varchar,sr.FecReg,103) as FecReg,
convert(varchar,sr.FecMdf,103) as FecMdf,
sr.UsuCrea,sr.UsuMdf,sr.Id_EstSR,esr.Descrip,
cc.Cd_CC,cc.Descrip as DescripCC,cc.NCorto as NCortoCC,
scc.Cd_SC,scc.Descrip as DescripSCC,scc.NCorto as NCortoSCC,
ssc.Cd_SS,ssc.Descrip as DescripSSC,ssc.NCorto as NCortoSSC,
sr.CA01,sr.CA02,sr.CA03,sr.CA04,sr.CA05
from SolicitudReq sr
Left Join Empresa e on e.Ruc=sr.RucE
Left Join CCostos cc on cc.RucE=sr.RucE and cc.Cd_CC = sr.Cd_CC
--Left Join CCSub scc on scc.RucE = sr.RucE and cc.Cd_CC = scc.Cd_CC and scc.Cd_SC= sr.Cd_SC
Left Join CCSub scc on scc.RucE = sr.RucE and scc.Cd_CC = cc.Cd_CC and scc.Cd_SC= sr.Cd_SC
--Left Join CCSubSub ssc on ssc.RucE=sr.RucE  and cc.Cd_CC = ssc.Cd_CC and scc.Cd_SC= ssc.Cd_SC and ssc.Cd_SS=sr.Cd_SS
Left Join CCSubSub ssc on ssc.RucE=sr.RucE  and cc.Cd_CC = ssc.Cd_CC and scc.Cd_SC= ssc.Cd_SC and ssc.Cd_SS=sr.Cd_SS
Left Join Area a on a.RucE = sr.RucE and a.Cd_Area=sr.Cd_Area
Left join EstadoSR esr on esr.Id_EstSR = sr.Id_EstSR
Where sr.RucE=@RucE and sr.Cd_SR=@Cd_SR

/*select * from SolicitudReq
select * from SolicitudReqDet*/
-------------------------------------------------------------------------------------------------
/*------INFORMACION DEL DETALLE DE LA SOLICITUD DE REQUERIMIENTOS-------*/
-------------------------------------------------------------------------------------------------
select d.RucE,d.Cd_SR,d.Item,d.Cd_Prod,pr.Nombre1,pr.Descrip as DescripProd,pr.CodCo1_ as CodCom,
d.Descrip as DescripDet,/*d.ID_UMP,*/ump.DescripAlt,--ump.Cd_UM,um.Nombre as NombreUM,um.NCorto as NCortoUM,
d.Cant,d.Obs,convert(varchar,d.FecMdf,103) as FecMdf ,d.UsuMdf,d.CA01,d.CA02,d.CA03,d.CA04,d.CA05,
um.Cd_UM,um.Nombre,um.NCorto
from SolicitudReqDet d 
Left Join Producto2 pr on pr.RucE=d.RucE and pr.Cd_Prod = d.Cd_Prod
Left Join Prod_UM ump on ump.RucE =d.RucE and ump.ID_UMP = d.ID_UMP and ump.Cd_Prod=pr.Cd_Prod
Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM
--Left Join UnidadMedida on um.Cd_UM = ump.Cd_UM
Where d.RucE=@RucE and d.Cd_SR=@Cd_SR

print @msj
/*Leyenda*/
--J : <Creado> ---> 06-12-2010
--exec dbo.Rpt_Compra_SolicitudReq '11111111111','SR00000005',null
GO
