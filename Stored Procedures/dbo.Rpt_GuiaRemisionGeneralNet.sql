SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare 
CREATE procedure [dbo].[Rpt_GuiaRemisionGeneralNet]
@RucE nvarchar(11),@Cd_GR varchar(8000)
--set @RucE = '11111111111'
--set @Cd_GR = '''GR00000387'',''GR000300383'''
as
Declare @Sql1 nvarchar(4000)
set @Sql1=
'
Select
e.RSocial, 
gr.RucE, 
gr.Cd_GR, 
gr.PesoTotalKg,
gr.FecEmi, 
gr.NroSre as NroSerie, 
gr.NroGR as NumeroGuia,
gr.AutorizadoPor,
gr.PtoPartida, 
isnull(GR.CA01,'''') as CA01GR,
isnull(GR.CA02,'''') as CA02GR,
isnull(GR.CA03,'''') as CA03GR,
isnull(GR.CA04,'''') as CA04GR,
isnull(GR.CA05,'''') as CA05GR,
isnull(GR.CA06,'''') as CA06GR,
isnull(GR.CA07,'''') as CA07GR,
isnull(GR.CA08,'''') as CA08GR,
isnull(GR.CA09,'''') as CA09GR,
isnull(GR.CA10,'''') as CA10GR,
isnull(GR.Obs,'''') as ObsGR,
gr.FecFinTras,
gr.FecIniTras,
gr.UsuCrea,
TipoOP.Nombre as TipoOperacion,
case when isnull(tr.Cd_Tra,'''')<>'''' then tr.RSocial else tr.ApPat + '' '' +tr.ApMat + '' '' + tr.Nom end as NombTrans, 
isnull(tr.Direc,'''') as DirTrans,
isnull(tr.Cd_TDI,'''') as TipDocTrans,
isnull(tdi.Descrip,'''') as TipDocTransNom,
isnull(tdi.NCorto,'''') as TipDocTransNCorto,
isnull(tr.NDoc,'''') as NDocTrans, 
isnull(tr.LicCond,''--'') as LicCondTrans, 
isnull(tr.NroPlaca,''--'') as NroPlacaTrans, 
isnull(tr.McaVeh,''--'') as MarcaVehiculoTrans,
isnull(tr.Obs,'''') as ObsTrans,
isnull(tr.Telf,'''') as Telf1Trans,
tr.CA01 as TRCA01 ,
tr.CA02 as TRCA02 ,
tr.CA03 as TRCA03 , 
tr.CA04 as TRCA04 ,
tr.CA05 as TRCA05 ,
gr.Cd_CC, 
gr.Cd_SC, 
gr.Cd_SS,
	(select udep.Nombre+''-''+upr.Nombre+''-''+ud.Nombre from Empresa e 
	left join UDist ud on ud.Cd_UDt = e.Ubigeo
	left join UProv upr on upr.Cd_UPv = LEFT(ud.Cd_UDt,4)
	left join UDepa udep on udep.Cd_UDp = LEFT(ud.Cd_UDt,2)
	where e.Ruc = '''+@RucE+''') as UbigeoEmpresa,
clt.Cd_Clt,
case when isnull(clt.RSocial,'''')<>'''' then clt.RSocial else clt.ApPat+'' ''+clt.ApMat+'' ''+clt.Nom end as NomCli,
isnull(clt.Direc,'''') as DirCli,
isnull(clt.Cd_TDI,'''') as TipDocCli,
isnull(tdi.Descrip,'''') as TipDocCliNom,
isnull(tdi.NCorto,'''') as TipDocCliNCorto,
isnull(clt.NDoc,'''') as NDocCli,
isnull(clt.Telf1,'''') as Telf1Cli,
isnull(clt.Telf2,'''') as Telf2Cli,
isnull(clt.Fax,'''') as FaxCli,
isnull(clt.Correo,'''') as CorreoCli,
isnull(clt.Ubigeo,'''') as UbigeoCli,
isnull(clt.Obs,'''') as ObsCli,
isnull(clt.CA01,'''') as CA01Cli,
isnull(clt.CA02,'''') as CA02Cli,
isnull(clt.CA03,'''') as CA03Cli,
isnull(clt.CA04,'''') as CA04Cli,
isnull(clt.CA05,'''') as CA05Cli,
isnull(clt.CA06,'''') as CA06Cli,
isnull(clt.CA07,'''') as CA07Cli,
isnull(clt.CA08,'''') as CA08Cli,
isnull(clt.CA09,'''') as CA09Cli,
isnull(clt.CA10,'''') as CA10Cli,
doc.FacRel'

declare @Sql2 nvarchar(4000)


set @Sql2='

from      GuiaRemision as gr 

		  --left join GRPtoLlegada GRL on GRL.RucE=GR.RucE and GRL.Cd_GR=GR.Cd_GR
          Left join Transportista tr on tr.RucE = gr.RucE and tr.Cd_tra = gr.Cd_Tra
          Left join TipoOperacion TipoOP on TipoOP.Cd_TO=GR.Cd_TO
          left join Empresa e on e.Ruc = gr.RucE   
          left join Cliente2 clt on clt.RucE = gr.RucE and clt.Cd_Clt = gr.Cd_Clt
          left join Proveedor2 prv on prv.RucE = gr.RucE and prv.Cd_Prv = gr.Cd_Prv
          left join TipDocIdn tdi on tdi.Cd_TDI = clt.Cd_TDI
          left join
          (
			select T2.Cd_GR,left(T2.t,len(T2.t)-1) as FacRel
			from(
				select distinct g.Cd_GR, 
					(
					 SELECT (td.NCorto+''-''+v.NroSre+''-''+v.NroDoc) + '' / ''
					 from GuiaXVenta gv
					 left join Venta v on v.RucE = gv.RucE and v.Cd_Vta = gv.Cd_Vta
					 left join TipDoc td on td.Cd_TD = v.Cd_TD
					 where gv.Cd_GR=g.Cd_GR and gv.RucE =  '''+@RucE+'''
					 order by gv.Cd_GR
					 for xml path('''')
					 ) as t
				from GuiaXVenta g where g.RucE =  '''+@RucE+''' and g.Cd_GR in ('+@Cd_GR+') 
				)as T2
          ) as doc on doc.Cd_GR = gr.Cd_GR
Where GR.RucE =  '''+@RucE+''' and GR.Cd_GR in ('+@Cd_GR+')'
Declare @Sql3 varchar(8000)
set @Sql3 =
'
select gd.*,p.Nombre1 + '' '' + isnull(gd.Obs, '''') as Nombre1,p.Nombre2,p.NCorto,p.Cta1,p.Cta2,p.CodCo1_ as CodCom1,p.CodCo2_ as CodCom2,p.CodCo2_ as CodCom3,p.CodBarras,p.FecCaducidad,p.Img,um.Nombre as NomUM,um.NCorto as NCortoUM , 
ump.Volumen as volumen
--,gd.Obs as ObsGr
 from
GuiaRemisionDet gd
left join Producto2 p on p.RucE = gd.RucE and p.Cd_Prod = gd.Cd_Prod
Left Join Prod_UM ump on ump.RucE=gd.RucE and ump.ID_UMP = gd.ID_UMP and  ump.Cd_Prod = p.Cd_Prod
Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM

where gd.RucE = '''+@RucE+''' and gd.Cd_GR in ('+@Cd_GR+')'


Declare @Sql4 varchar(8000)

set @Sql4 =
'
select Cd_GR,Direc as DirecLlegada from GRPtoLlegada where RucE = '''+@RucE+''' and Cd_GR in ('+@Cd_GR+')'
declare @Sql5 varchar(8000)
set @Sql5='select gr.Cd_GR,v.CA01,v.CA02,v.CA03,v.CA04,v.CA05,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10,v.CA11,
          v.CA12,v.CA13,v.CA14,v.CA15,v.CA16,v.CA17,v.CA18,v.CA19,v.CA20,v.CA21,v.CA22,v.CA23,v.CA24,v.CA25 
		  from  GuiaRemision as gr 
		  inner join GuiaXVenta gy on gy.RucE = gr.RucE and gy.Cd_GR = gr.Cd_GR
		  inner join Venta v on v.RucE = gy.RucE and  v.Cd_Vta = gy.Cd_Vta where gr.RucE= '''+@RucE+''' and gr.Cd_GR in ('+@Cd_GR+')'
print (@Sql1+@Sql2)
print (@Sql3)
print (@Sql4)
print (@Sql5)
exec (@Sql1+@Sql2)
exec (@Sql3)
exec (@Sql4)
exec (@Sql5)
--<Creado: Javier Acho>
--Prueba Exec Rpt_GuiaRemisionGeneralNet '20102028687','''GR00001046'''
--<Modificado: Rafael>
--Agregado Obs a cada Producto de la guía (Aparecera solo si hay obs)
















GO
