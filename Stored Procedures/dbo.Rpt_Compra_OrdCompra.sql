SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_Compra_OrdCompra]
@RucE nvarchar(11),
@Cd_OC nvarchar(10),
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL OFF

select 
	e.Ruc,e.RSocial as RSocialEmp,e.Direccion as DirecEmp,e.Telef as TelefEmp,
	oc.Cd_OC,oc.NroOC,convert(varchar,oc.FecE,103) as FecEmi, convert(varchar,oc.FecEntR,103) as FecEntR,
	oc.Obs,oc.Valor as ValorOC, 
	case(IsNull(oc.TotDsctoP,0)) when 0 then oc.TotDsctoI else oc.TotDsctoP end as DsctoTot,
	oc.ValorNeto as ValorNetoOC,
	case(IsNull(oc.DsctoFnzP,0)) when 0 then oc.DsctoFnzI else oc.DsctoFnzP end as DsctoFnz,
	oc.BIM as BIM_OC,IsNull(oc.IGV,'0.00') as IGV_OC,oc.Total as Total_OC, oc.CamMda,oc.IB_Aten, 
	oc.AutdoPorN1,oc.AutdoPorN2,oc.AutdoPorN3,oc.IC_NAut,oc.Cd_SCo as CodSCom,
	convert(varchar,oc.FecReg,103) as FecReg,
	convert(varchar,oc.FecMdf,103) as FecMdf, 
	oc.UsuCrea,oc.UsuModf,
	oc.CA01 as OCA01,oc.CA02 as OCA02, oc.CA03 as OCA03,oc.CA04 as OCA04,
	oc.CA05 as OCA05,oc.CA06 as OCA06,oc.CA07 as OCA07,oc.CA08 as OCA08,
	oc.CA09 as OCA09,oc.CA10 as OCA10,
	oc.Cd_Mda,mda.Nombre as NomMda,mda.Simbolo as SimMda,
	oc.Cd_FPC,fpc.Nombre as NombreFPC,fpc.NCorto as NCortoFPC,
	oc.Cd_Area,a.Descrip as DescripArea,a.NCorto as NCortoArea,
	oc.Cd_CC,cc.Descrip as DescripCC,cc.NCorto as NCortoCC,
	oc.Cd_SC,scc.Descrip as DescripSCC,scc.NCorto as NCortoSCC,
	oc.Cd_SS,ssc.Descrip as DescripSSC,ssc.NCorto as NCortoSSC,
	oc.Cd_Prv,prv.NDoc,case(isnull(prv.RSocial,'0')) when '0' then prv.ApPat + ' ' + prv.ApMat + ' ' + prv.Nom else prv.RSocial end as NomPrv,
	prv.Ubigeo,prv.Direc as DirecPrv,prv.Telf1 as Telf1Prv, prv.Telf2 as Telf2Prv, prv.Fax, prv.Correo,prv.PWeb,prv.Obs as ObsPrv,
	con.ApPat + ' ' + con.ApMat + ' ' + con.Nom as NomCon,con.Direc as DirecCon,con.Telf as TelfCon,con.Correo as CorreoCon,
	con.Cargo as CargoCon,
	prv.Cd_TDI,tdi.Descrip as DescripTDI,tdi.NCorto as NCortoTDI,
	prv.Cd_Pais,pa.Nombre as NomPais,pa.Siglas,
	usu.NomComp

from OrdCompra oc
	Left Join Empresa e on e.Ruc=oc.RucE	
	Left Join Moneda mda on mda.Cd_Mda = oc.Cd_Mda
	Left Join Proveedor2 prv on prv.RucE= oc.RucE and prv.Cd_Prv = oc.Cd_Prv
	Left Join Contacto con on con.RucE = prv.RucE and con.Cd_Prv=prv.Cd_Prv and con.IB_Prin=1
	Left Join TipDocIdn tdi on tdi.Cd_TDI = prv.Cd_TDI
	Left Join Pais pa on pa.Cd_Pais = prv.Cd_Pais
	Left Join FormaPC fpc on fpc.Cd_FPC = oc.Cd_FPC
	Left Join Area a on a.RucE= oc.RucE and a.Cd_Area = oc.Cd_Area
	Left Join CCostos cc on cc.RucE=oc.RucE and cc.Cd_CC = oc.Cd_CC
	Left Join CCSub scc on scc.RucE = oc.RucE and cc.Cd_CC = scc.Cd_CC and scc.Cd_SC= oc.Cd_SC
	Left Join CCSubSub ssc on ssc.RucE=oc.RucE  and cc.Cd_CC = ssc.Cd_CC and scc.Cd_SC= ssc.Cd_SC and ssc.Cd_SS=oc.Cd_SS
	Left Join Usuario usu on usu.NomUsu = oc.UsuCrea
where oc.RucE=@RucE and oc.Cd_Oc=@Cd_OC

select 
	det.RucE,det.Cd_OC,det.Item,
	det.Descrip as DescripDet,det.PU,det.Cant,det.Valor,det.DsctoP,det.DsctoI,det.BIM,IsNull(det.IGV,'0.00')as IGV,det.Total,det.PendRcb,
	det.Obs as ObsDet,convert(varchar,det.FecMdf,103) as FecMdf,det.UsuMdf,det.CA01 as DCA01,det.CA02 as DCA02,
	det.CA03 as DCA03,det.CA04 as DCA04,det.CA05 as DCA05,
	det.Cd_Prod,pr.Nombre1 as NomProd,pr.Descrip as DescripProd,pr.CodCo1_ as CodCom,
	det.ID_UMP,ump.DescripAlt,
	det.Cd_Alm,alm.Cd_Alm,alm.Nombre as NomAlm,alm.NCorto as NCortoAlm,alm.Direccion as DirAlm,alm.Telef as TelefAlm,
	um.Cd_UM as CodUM,um.Nombre as NomUM,um.NCorto as NCortoUM
from OrdCompraDet det
	Left Join Almacen alm on alm.RucE = det.RucE and alm.Cd_Alm = det.Cd_Alm
	Left Join Producto2 pr on pr.RucE=det.RucE and pr.Cd_Prod = det.Cd_Prod
	Left Join Prod_UM ump on ump.RucE =det.RucE and ump.ID_UMP = det.ID_UMP and ump.Cd_Prod=pr.Cd_Prod
	Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM
where det.RucE=@RucE and det.Cd_Oc=@Cd_OC

print @msj

/*Leyenda*/
--J : <Creado> ---> 06-12-2010
--exec dbo.Rpt_Compra_OrdCompra '11111111111','OC00000002',null
GO
