SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_CotizacionCons_RptCorreo1]

@RucE nvarchar(11),
@CadCot nvarchar(4000),

@msj varchar(100) output

As


DECLARE @SQL_P1 VARCHAR(8000) SET @SQL_P1=''
DECLARE @SQL_P2 VARCHAR(8000) SET @SQL_P2=''
DECLARE @SQL_P3 VARCHAR(8000) SET @SQL_P3=''

Set @SQL_P1 =
	'
	Select 
		c.RucE,e.RSocial,
		c.Cd_Cot,
		c.NroCot,
		Convert(varchar,c.FecEmi,103) As FecEmi,
		Convert(varchar,c.FecCad,103) As FecCad,
		f.Nombre As NomFPC,
		c.Asunto,
		t.NDoc As NroCli, isnull(t.RSocial,isnull(t.ApPat,'''')+'' ''+isnull(t.ApMat,'''')+'' ''+isnull(t.Nom,'''')) As NomCli,
		v.NDoc As NroVdr, isnull(v.RSocial,isnull(v.ApPat,'''')+'' ''+isnull(v.ApMat,'''')+'' ''+isnull(v.Nom,'''')) As NomVdr,
		c.CostoTot,
		c.Valor,
		c.TotDsctoP,
		c.TotDsctoI,
		c.INF,
		c.DsctoFnzInf_P,
		c.DsctoFnzInf_I,
		c.INF_Neto,
		c.BIM,
		c.DsctoFnzAf_P,
		c.DsctoFnzAf_I,
		c.BIM_Neto,
		c.IGV,
		c.Total,
		c.MU_Porc,
		c.MU_Imp,
		c.Cd_Mda,
		c.CamMda,
		a.Descrip As NomArea,
		c.Obs,
		c.UsuCrea,
		c.CdCot_Base,
		t.Direc as Direccion ,
		t.Telf1,
		t.Telf2,
		t.Fax,
		t.Correo,
		v.Telf1 as TelfVdr,
		v.Correo as CorreoVdr,
		c.CA01,
		c.CA02,
		c.CA03,
		c.CA04,
		c.CA05,
		v.CA01 as CA01Vdr,
		v.CA02 as CA02Vdr,
		v.CA03 as CA03Vdr,
		v.CA04 as CA04Vdr,
		v.CA05 as CA05Vdr,
		v.CA06 as CA06Vdr,
		v.CA07 as CA07Vdr,
		v.CA08 as CA08Vdr,
		v.CA09 as CA09Vdr,
		v.CA10 as CA10Vdr,
		u.NomComp as NomCompUsuCrea,
		c.FecEmi as FecEmi2,
		c.FecCad as FecCad2,
		u.Correo1 as CorreoUsuCrea,
		c.CA06,
		c.CA07,
		c.CA08,
		c.CA09,
		c.CA10,
		c.CA11,
		c.CA12,
		c.CA13,
		c.CA14,
		c.CA15
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
		,e.Direccion as DirecEmp
		,e.Telef as TelfEmpr
		,isnull(left(v.Nom,1)+''.''+left(v.ApPat,1)+''.''+left(v.ApMat,1)+''.'',isnull(v.RSocial,'''')) as IniVdr
		,u.Numero as NumUsuCrea
		,u2.NomComp as NomCompAutorizadoPor
		,v.Telf2 as TelfVdr2
		,ud.Nombre+''-''+upr.Nombre+''-''+udep.Nombre as UbigeoCLI
		,e.Logo
	from 
		Cotizacion c
		Inner Join Empresa e On e.Ruc=c.RucE
		Inner Join FormaPC f On f.Cd_FPC=c.Cd_FPC
		Left Join Cliente2 t On t.RucE=c.RucE and t.Cd_Clt=c.Cd_Clt
		Left Join Vendedor2 v On v.RucE=c.RucE and v.Cd_Vdr=c.Cd_Vdr
		LEFt Join Area a On a.RucE=c.RucE and a.Cd_Area=c.Cd_Area
		left join Usuario u on u.NomUsu = c.UsuCrea
		left join Usuario u2 on u2.NomUsu = c.AutorizadoPor
		left join UDist ud on ud.Cd_UDt = t.Ubigeo
		left join UProv upr on upr.Cd_UPv = LEFT(ud.Cd_UDt,4)
		left join UDepa udep on udep.Cd_UDp = LEFT(ud.Cd_UDt,2)
	Where 
		c.RucE='''+@RucE+'''
		and c.Cd_Cot in ('''+@CadCot+''')
	'

Set @SQL_P2=
	'
	Select 
		d.Cd_Cot,
		Convert(varchar,d.ID_CtD) As ID_CtD,
		isnull(isnull(d.Cd_Prod,d.Cd_Srv),'''') As Cd_Item,
		pr.PagWeb,
		isnull(d.Descrip,'''') As NomItem,
		isnull(u.Nombre,'''') As NomUM,isnull(u.NCorto,'''') As SimUM,
		Convert(decimal(6,2),ROUND(isnull(d.CU,0),2)) As CU,
		Convert(decimal(6,2),ROUND(isnull(d.Costo,0.00),2)) As Costo,
		Convert(decimal(6,2),ROUND(isnull(d.PU,0.00),2)) As PU,
		Convert(decimal(6,2),ROUND(isnull(d.Cant,0.00),2)) As Cant,
		Convert(decimal(6,2),ROUND(isnull(d.Valor,0.00),2)) As Valor,
		Convert(decimal(6,2),ROUND(isnull(d.DsctoP,0.00),2)) As DsctoP,
		Convert(decimal(6,2),ROUND(isnull(d.DsctoI,0.00),2)) As DsctoI,
		Convert(decimal(6,2),ROUND(isnull(d.BIM,0.00),2)) As BIM,
		Convert(decimal(6,2),ROUND(isnull(d.IGV,0.00),2)) As IGV,
		Convert(decimal(6,2),ROUND(isnull(d.Total,0.00),2)) As Total,
		Convert(decimal(6,2),ROUND(isnull(d.MU_Porc,0.00),2)) As MU_Porc,
		Convert(decimal(6,2),ROUND(isnull(d.MU_Imp,0.00),2)) As MU_Imp,
		isnull(d.Obs,'''') As Obs,
		d.CA01,
		d.CA02,
		d.CA03,
		d.CA04,
		d.CA05,pum.DescripAlt as DescripUM,
		
			case(IsNull(pr.Cd_Prod,''0'')) when ''0'' then srv.CA01 else pr.CA01 end as CA01PrSrv,
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
		,mar.NCorto as NCortoMarca,
		pr.Codco1_ as CodCom
		
		
		
	From
		CotizacionDet d
		Left Join Servicio2 srv on srv.Cd_Srv = d.Cd_Srv and srv.RucE= d.RucE	
		Left Join Producto2 pr on pr.Cd_Prod = d.Cd_Prod and pr.RucE = d.RucE	
		left join Marca mar on mar.RucE = d.RucE and mar.Cd_Mca = pr.Cd_Mca
		left join Prod_UM pum on pum.RucE = d.RucE and pum.Cd_Prod = d.Cd_Prod and pum.ID_UMP = d.ID_UMP
		Left Join UnidadMedida u On u.Cd_UM=pum.Cd_UM
	Where
		d.RucE='''+@RucE+'''
		and d.Cd_Cot in ('''+@CadCot+''') 
	'
	--select*from Marca
	--select cd_Mca from Producto2
	--select*from Modelo
	--select*from CotizacionDet

Set @SQL_P3=
	'
	Select
		p.Cd_Cot,
		Convert(varchar,p.ID_CtD) As ID_CtD,
		p.Item,
		p.Cpto,
		p.Valor
	From 
		CotizacionProdDet p
	Where
		p.RucE='''+@RucE+'''
		and p.Cd_Cot in ('''+@CadCot+''')
	'
/*******************Contactos*********************/
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
where cd.RucE ='''+@RucE+''' and cd.Codigo in ('''+@CadCot+''')'


PRINT @SQL_P1
PRINT @SQL_P2
PRINT @SQL_P3
PRINT @SQL3

EXEC (@SQL_P1+@SQL_P2+@SQL_P3+@SQL3)
--select * from cotizacion

--[dbo].[Vta_CotizacionCons_Rpt] '20102028687','''CT00000041''',null

-- Leyedan --
-- DI : 15/02/2011 <Creacion del procedimiento almacenado>

--select*from empresa where Ruc=20102028687
--select*from Cotizacion where RucE='20102028687' and NroCot ='NRO-00000000041'
--select * from Empresa where Rsocial like '%Kbr%'
GO
