SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_Compra_OrdPedido3]
@RucE nvarchar(11),
@Cd_OP nvarchar(4000),
@msj varchar(400) output
as

DECLARE @SQL1 varchar(8000)
DECLARE @SQL2 varchar(8000)

/**************************CABECERA************************************************/
SET @SQL1 =
'
select 
	e.Ruc,e.RSocial as RSocialEmp,e.Direccion as DirecEmp,e.Telef as TelefEmp,
	op.Cd_OP,op.NroOP,convert(varchar,op.FecE,103) as FecEmi,convert(varchar,op.FecEnt,103) as FecEnt,op.DirecEnt,
	op.Obs,op.Valor as ValorOP, 
	case(IsNull(op.TotDsctoP,0)) when 0 then op.TotDsctoI else op.TotDsctoP end as DsctoTot,
	op.ValorNeto as ValorNetoOP,
	case(IsNull(op.DsctoFnzAf_P,0)) when 0 then op.DsctoFnzAf_P else  op.DsctoFnzAf_I end as DsctoFnz,
	op.BIM_Neto as BIM_OP,
	IsNull(op.IGV,0.00) as IGV_OP,
	op.Total as Total_OP,
	op.CamMda,
 	op.AutorizadoPor,
	convert(varchar,op.FecReg,103) as FecReg,
	convert(varchar,op.FecMdf,103) as FecMdf, 
	op.UsuCrea,op.UsuMdf,
	op.CA01 as OCA01,op.CA02 as OCA02, op.CA03 as OCA03,op.CA04 as OCA04,
	op.CA05 as OCA05,op.CA06 as OCA06,op.CA07 as OCA07,op.CA08 as OCA08,
	op.CA09 as OCA09,op.CA10 as OCA10,
	op.Cd_Mda,mda.Nombre as NomMda,mda.Simbolo as SimMda,
	op.Cd_FPC,fpc.Nombre as NombreFPC,fpc.NCorto as NCortoFPC,
	op.Cd_Area,a.Descrip as DescripArea,a.NCorto as NCortoArea,
	clt.NDoc as NDoc,
	case(isnull(len(clt.RSocial),0)) when 0 then clt.ApPat +'' ''+ clt.ApMat +'',''+ clt.Nom else clt.RSocial end as NombCli
	,clt.Direc as DirecCli,clt.Telf1 as TlfCli1, clt.Telf2 as  TlfCli2
	,clt.CA01 as CA01Cli,clt.CA02 as CA02Cli,clt.CA03 as CA03Cli,clt.CA04 as CA04Cli,clt.CA05 as CA05Cli
	,clt.CA06 as CA06Cli ,clt.CA07 as CA07Cli ,clt.CA08 as CA08Cli ,clt.CA09 as CA09Cli ,clt.CA10 as CA10Cli
	--,de.Direc as DireccionEntrega
	,case when ISNULL(v.RSocial,'''')='''' then isnull(v.Nom,'''') + '' '' + isnull(v.ApPat,'''') + '' '' + isnull(v.ApMat,'''') else v.RSocial end as NomVDR 
	,v.CA01 as CA01Vdr
	,v.CA02 as CA02Vdr
	,v.CA03 as CA03Vdr
	,v.CA04 as CA04Vdr
	,v.CA05 as CA05Vdr
	,v.CA06 as CA06Vdr
	,v.CA07 as CA07Vdr
	,v.CA08 as CA08Vdr
	,v.CA09 as CA09Vdr
	,v.CA10 as CA10Vdr
	,v.Correo as CorreoVdr
	,v.Telf1 as TelfVdr
	,'''' as NomCon
	,'''' as CorreoCon
	,'''' as Telf1Con
	,'''' as Telf2Con
	,'''' as CargoCon
	,'''' as DirecCon
	,'''' as CA01Con
	,'''' as CA02Con
	,'''' as CA03Con
	,'''' as CA04Con
	,'''' as CA05Con
	,op.FecE as FecEmi2
	,op.FecEnt as FecEnt2
	,usu.NomComp as NomCompUsuCrea
	,usu2.NomComp as NomCompAutorizadoPor
	,isnull(left(v.Nom,1)+''.''+left(v.ApPat,1)+''.''+left(v.ApMat,1)+''.'',isnull(v.RSocial,'''')) as IniVdr
	,usu.NomComp as NomCompUsuCrea
	,usu.NomUsu as UsuCrea
	,usu.Correo1 as CorreoUsuCrea
	,usu.Numero as NumUsuCrea
	,cot.Cd_Cot
	,cot.NroCot
	,cot.CA01 as CA01COT
	,cot.CA02 as CA02COT
	,cot.CA03 as CA03COT
	,cot.CA04 as CA04COT
	,cot.CA05 as CA05COT
	,cot.CA06 as CA06COT
	,cot.CA07 as CA07COT
	,cot.CA08 as CA08COT
	,cot.CA09 as CA09COT
	,cot.CA10 as CA10COT
	,cot.CA11 as CA11COT
	,cot.CA12 as CA12COT
	,cot.CA13 as CA13COT
	,cot.CA14 as CA14COT
	,cot.CA15 as CA15COT
	,ud.Nombre+''-''+upr.Nombre+''-''+udep.Nombre as UbigeoCLI
	,e.Logo
from OrdPedido op
	Left Join Empresa e on e.Ruc=op.RucE	
	Left Join Moneda mda on mda.Cd_Mda = op.Cd_Mda
	Left Join FormaPC fpc on fpc.Cd_FPC = op.Cd_FPC
	Left Join Area a on a.RucE= op.RucE and a.Cd_Area = op.Cd_Area
	Left Join Usuario usu on usu.NomUsu = op.UsuCrea
	Left Join Usuario usu2 on usu2.NomUsu = op.AutorizadoPor
	left join Cliente2 clt on clt.RucE = op.RucE and clt.Cd_Clt = op.Cd_Clt 
	Left join Vendedor2 v on op.RucE = v.RucE and op.Cd_Vdr = v.Cd_Vdr
	left join Cotizacion cot on cot.RucE = op.RucE and cot.Cd_Cot = op.Cd_Cot
	left join UDist ud on ud.Cd_UDt = clt.Ubigeo
	left join UProv upr on upr.Cd_UPv = LEFT(ud.Cd_UDt,4)
	left join UDepa udep on udep.Cd_UDp = LEFT(ud.Cd_UDt,2)

	where op.RucE='''+@RucE+''' and op.Cd_Op in ('+@Cd_OP+')'




/*******************************DETALLE*******************************************************/
SET @SQL2 =
'
select 
	det.RucE,det.Cd_OP,det.Item,
	det.Descrip as DescripDet,det.PU,det.Cant,det.Valor,det.DsctoP,det.DsctoI,det.BIM,IsNull(det.IGV,''0.00'')as IGV,det.Total,det.PendEnt,

	det.Obs as ObsDet,convert(varchar,det.FecMdf,103) as FecMdf,det.UsuMdf,det.CA01 as DCA01,det.CA02 as DCA02,
	det.CA03 as DCA03,det.CA04 as DCA04,det.CA05 as DCA05,
	det.ID_UMP,ump.DescripAlt,
	um.Cd_UM as CodUM,um.Nombre as NomUM,um.NCorto as NCortoUM,
	
	case(IsNull(det.Cd_Prod,''0'')) when ''0'' then det.Cd_Srv else det.Cd_Prod end as Cd_PrSrv,
	case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CodCo else pr.CodCo1_ end as CodCoPrSrv,
	case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.Nombre else pr.Nombre1 end as NomPrSrv,
	case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.Descrip else pr.Descrip end as DescripPrSrv,
	case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.NCorto else pr.NCorto end as NCortoPrSrv
	--case(vd.IGV)When 0 then 0 else vd.IMP end as AFECTO,
	--case(vd.IGV)When 0 then vd.IMP else 0 end as INAFECTO
	,isnull(det.Cd_Alm,'''') as Cd_Alm
	,isnull(alm.Nombre,'''') as NomAlm
	,isnull(alm.NCorto,'''') as NCortoAlm
	,case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA01 else pr.CA01 end as CA01PrSrv,
	case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA02 else pr.CA02 end as CA02PrSrv,
	case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA03 else pr.CA03 end as CA03PrSrv,
	case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA04 else pr.CA04 end as CA04PrSrv,
	case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA05 else pr.CA05 end as CA05PrSrv,
	case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA06 else pr.CA06 end as CA06PrSrv,
	case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA07 else pr.CA07 end as CA07PrSrv,
	case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA08 else pr.CA08 end as CA08PrSrv,
	case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA09 else pr.CA09 end as CA09PrSrv,
	case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA10 else pr.CA10 end as CA10PrSrv
	,mar.Cd_Mca as CodMarca
	,mar.Nombre as NomMarca
	,mar.Descrip as DescripMarca
	,mar.NCorto as NCortoMarca
	,ump.DescripAlt as DescripUM
from OrdPedidoDet det
	Left Join Producto2 pr on pr.RucE=det.RucE and pr.Cd_Prod = det.Cd_Prod
	left join Marca mar on mar.RucE = det.RucE and mar.Cd_Mca = pr.Cd_Mca
	Left Join Prod_UM ump on ump.RucE =det.RucE and ump.ID_UMP = det.ID_UMP and ump.Cd_Prod=pr.Cd_Prod
	Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM
	Left Join Servicio2 srv on srv.Cd_Srv = det.Cd_Srv and srv.RucE= det.RucE
	--left join VentaDet vd on vd.Ruce = det.ruce and(vd.cd_prod = det.cd_prod and vd.cd_srv = det.cd_srv)
	left join almacen alm on alm.RucE = det.RucE and alm.Cd_Alm = det.Cd_Alm
where det.RucE='''+@RucE+''' and det.Cd_OP in ('+@Cd_OP+')'

/****************************************Contactos**********************************************************/
DECLARE @SQL3 varchar(8000)
set @SQL3 = '
select 
cd.RucE
,cd.Codigo
,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''') as NomCon
,c.Correo as CorreoCon
,c.Telf as Telf2Con
,c.Cargo as CargoCon
,c.Direc as DirecCon
,c.CA01 as CA01Con
,c.CA02 as CA02Con
,c.CA03 as CA03Con
,c.CA04 as CA04Con
,c.CA05 as CA05Con
from ContactoXDocumento cd 
inner join Contacto c on c.RucE = cd.RucE and c.Id_Gen = cd.Id_Gen
where cd.RucE ='''+@RucE+''' and cd.Codigo in ('+@Cd_OP+')'




print @SQL1
print @SQL2
print @SQL3
EXEC (@SQL1+@SQL2+@SQL3)

/*Leyenda*/
--Javier : <Creado> ---> 14-03-2011
--Javier : <Modificado aumnte el campo de direccion de entrega del cliente.> --> 16/03/2011

--exec dbo.Rpt_Compra_OrdPedido '11111111111','OP00000003',null
--exec [Rpt_Compra_OrdPedido3] '20536756541','''OP00000021''',null
/*
declare @cd_op nvarchar(4000)
set @cd_op = '''OP00000047'''
--exec dbo.Rpt_Compra_OrdPedido3 '20101949461',@cd_op,null
exec dbo.Rpt_Compra_OrdPedido3 '20102028687',@cd_op,null
select * from OrdPedido where ruce= '11111111111' and cd_OP = 'OP00000092'
*/
/*
select opd.cd_prod,opd.cd_srv, vd.IMP, vd.IGV, vd.Total from OrdPedidoDet opd
left join VentaDet vd on opd.ruce = vd.ruce and (vd.cd_prod = opd.cd_prod or vd.cd_srv = opd.cd_srv)
where opd.cd_op = 'OP00000003' and opd.ruce= '11111111111'
*/










GO
