SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Rpt_Compra_SolicitudCom2]
@RucE nvarchar(11),
@Cd_SCo nvarchar(2000),
@Cd_Prv nvarchar(2000),
@msj varchar(100) output
as
SET CONCAT_NULL_YIELDS_NULL OFF

	Declare @part1 varchar(4000)
	set @part1=
	'select
	scpr.RucE,e.RSocial as RSocialEmp,e.Direccion as DireccionEmp,isnull(e.Logo,null) as Logo,
	sco.Cd_SCo, sco.NroSC,Convert(varchar,sco.FecEmi,103) as FecEmi,
	Convert(varchar,sco.FecEntR,103) as FecEntR,sco.Asunto,sco.Obs,sco.ElaboradoPor,
	sco.AutorizadoPor,sco.Cd_SR,Convert(varchar,sco.FecReg,103) as FecReg,
	usu.NomComp as UsuCrea,--sco.UsuCrea,
	sco.UsuMdf,sco.CA01 as SCA01,sco.CA02 as SCA02,sco.CA03 as SCA03,
	sco.CA04 as SCA04,sco.CA05 as SCA05,
	sco.Cd_FPC,fpc.Nombre as NombreFPC,fpc.NCorto as NCortoFPC,
	sco.Cd_Area,a.Descrip as DescripArea,a.NCorto as NCortoArea,
	sco.Id_EstSC,est.Descrip as DescripEstSC,
	sco.Cd_CC,cc.Descrip as DescripCC,cc.NCorto as NCortoCC,
	sco.Cd_SC,scc.Descrip as DescripSCC,scc.NCorto as NCortoSCC,
	sco.Cd_SS,ssc.Descrip as DescripSSC,ssc.NCorto as NCortoSSC,
	--Proveedor
	scpr.Cd_Prv,prv.NDoc,case(isnull(prv.RSocial,''0'')) when ''0'' then prv.ApPat + '' '' + prv.ApMat + '' '' + prv.Nom else prv.RSocial end as NomPrv,
	prv.Ubigeo,prv.Direc as DirecPrv,prv.Telf1 as Telf1Prv, prv.Telf2 as Telf2Prv, prv.Fax, prv.Correo,prv.PWeb,prv.Obs as ObsPrv,
	prv.Cd_TDI,tdi.Descrip as DescripTDI,tdi.NCorto as NCortoTDI,
	prv.Cd_Pais,pa.Nombre as NomPais,pa.Siglas,
	con.ApPat + '' '' + con.ApMat + '' '' + con.Nom as NomCon,con.Direc as DirecCon,con.Telf as TelfCon,con.Correo as CorreoCon,
	con.Cargo as CargoCon
	from SCxProv scpr
	Left Join Empresa e on e.Ruc=scpr.RucE
	Left Join SolicitudCom sco on sco.RucE= scpr.RucE and sco.Cd_SCo = scpr.Cd_SCo
	left join usuario usu on usu.NomUsu = sco.UsuCrea
	Left Join Proveedor2 prv on prv.RucE= scpr.RucE and prv.Cd_Prv = scpr.Cd_Prv
	Left Join Contacto con on con.RucE = prv.RucE and con.Cd_Prv=prv.Cd_Prv and con.IB_Prin=1
	Left Join TipDocIdn tdi on tdi.Cd_TDI = prv.Cd_TDI
	Left Join Pais pa on pa.Cd_Pais = prv.Cd_Pais
	Left Join FormaPC fpc on fpc.Cd_FPC = sco.Cd_FPC
	Left Join Area a on a.RucE= sco.RucE and a.Cd_Area = sco.Cd_Area
	Left Join EstadoSC est on est.Id_EstSC = sco.Id_EstSC
	Left Join CCostos cc on cc.RucE=sco.RucE and cc.Cd_CC = sco.Cd_CC
	Left Join CCSub scc on scc.RucE = sco.RucE and cc.Cd_CC = scc.Cd_CC and scc.Cd_SC= sco.Cd_SC
	Left Join CCSubSub ssc on ssc.RucE=sco.RucE  and cc.Cd_CC = ssc.Cd_CC and scc.Cd_SC= ssc.Cd_SC and ssc.Cd_SS=sco.Cd_SS '
	Declare @part2 varchar(4000)
	set @part2=
	' where scpr.RucE= '''+@RucE+''' and scpr.Cd_SCo = '''+ @Cd_SCo +''' and scpr.Cd_Prv in'+'('+@Cd_Prv+') '	

	
	Declare @part3 varchar(4000)
	set @part3=
	'select d.Cd_SC,d.Item,d.Cd_Prod,pr.Nombre1 as NomProd,pr.Descrip as DescripProd,pr.CodCo1_ as CodCom,
	d.Descrip as DescripDet,ump.DescripAlt,d.Cant as DCant,d.Obs as ObsDet,convert(varchar,d.FecMdf,103) as FecMdf,
	d.UsuMdf,d.CA01 as DCA01,d.CA02 as DCA02,d.CA03 as DCA02,d.CA03 as DCA03,d.CA04 as DCA04,d.CA05 as DCA05,
	um.Cd_UM as CodUM,um.Nombre as NomUM,um.NCorto as NCortoUM,sp.Cd_Prv
	from SolicitudComDet d 
	Left join SCxProv sp on sp.RucE = d.RucE and sp.Cd_SCo = d.Cd_SC
	Left Join Producto2 pr on pr.RucE=d.RucE and pr.Cd_Prod = d.Cd_Prod
	Left Join Prod_UM ump on ump.RucE =d.RucE and ump.ID_UMP = d.ID_UMP and ump.Cd_Prod=pr.Cd_Prod
	Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM '
	Declare @part4 varchar(4000)
	set @part4=
	' where d.RucE='''+@RucE+''' and  d.Cd_SC = '''+@Cd_SCo+''''
	/*print @part1
	print '-----'
	print @part2
	print '-----'
	print @part3
	print '-----'
	print @part4*/
	exec (@part1+@part2+@part3+@part4)
	print (@part1+@part2+@part3+@part4)
--select * from usuario


print @msj
/*Leyenda*/
--JA : <Creado> <17/07/2012>
--exec Rpt_Compra_SolicitudCom2 '20546792464','SC00000001','''PRV0004'',''PRV0003''',null
GO
