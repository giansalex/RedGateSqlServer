SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Rpt_VentaDetallada1 '11111111111','2012','01','','','01/03/2012','30/03/2012','','','','','','PD00007'
CREATE procedure [dbo].[Rpt_VentaDetallada2]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
--@Prdo char(2),
@vendedor char(7),
@Area varchar(50),
@FecIni datetime,--nvarchar(10),
@FecFin datetime,   --nvarchar(10)
@msj varchar(100) output,
@Cd_Clt char(10),
@Cd_CC varchar(8000),
@Cd_SC varchar(8000),
@Cd_SS varchar(8000),
@Cd_Prod char(7)
as
---------CABECERA-----------------------------------------------
declare @Cons1 varchar(8000)
declare @Cons2 varchar(8000)
declare @ConsCC varchar(50),@ConsSC varchar(50),@ConsSS varchar(50)
set @ConsCC='' set @ConsSC='' set @ConsSS=''
declare @mcons1 varchar(5),@mcons2 varchar(5),@mcons3 varchar(5)
set @mcons1='' set @mcons2='' set @mcons3=''

if(Isnull(@Cd_CC,'')<>'')
Begin
	set @ConsCC='and v.Cd_CC in ('
	set @mcons1=') '
End
if(Isnull(@Cd_SC,'')<>'')
Begin
	set @ConsSC='and v.Cd_SC in ('
	set @mcons2=') '
End
if(Isnull(@Cd_SS,'')<>'')
Begin
	set @ConsSS='and v.Cd_SS in ('
	set @mcons3=') '
End

--select * from moneda
--select * from ventadet where ruce='11111111111'
--cast(case when Cd_Mda='''+Convert(varchar,Isnull(@Cd_Mda,''))+
--''' then  v.Total  else case when isnull('''+Convert(varchar,isnull(@Cd_Mda,''))+''','''')=''01'' then v.Total*v.CamMda else  v.Total/v.CamMda end end as decimal(16,2)) as Total
		
set @Cons1='
	SELECT 
		v.Prdo,(v.NroSre+''-''+v.NroDoc) as tipdoc ,convert (nvarchar,v.fecMov,103)as fecMov,cl.Ndoc as Doc_Cli,
		case  when isnull(cl.RSocial,'''')='''' then isnull(cl.ApPat,'''') +'' ''+isnull(cl.ApMat,'''')+'' ''+isnull(cl.Nom,'''') else cl.RSocial end as cliente,
		'''' as Cd_Prod,'''' as CodCo1_, '''' as Descrip, '''' as Cd_CC, '''' as Cd_SC, '''' as Cd_SS, 
		'''' as Valor, '''' as Cant, v.BIM_Neto as  IMP,(case when(isnull(convert(nvarchar,v.IGV),'''')='''') then 0.0 else v.IGV end ) as IGV,
		cast(case when Cd_Mda='''+Convert(varchar,Isnull(@Cd_Mda,''))+
		''' then  v.Total  else case when isnull('''+Convert(varchar,isnull(@Cd_Mda,''))+''','''')=''01'' then v.Total*v.CamMda else  v.Total/v.CamMda end end as decimal(16,2)) as Total
		, case when isnull(v.Cd_Vdr,'''')='''' then ''No posee Vdr'' else v.Cd_Vdr end as cd_Vdr,
		case when isnull(v2.NDoc,'''')='''' then ''No hay Doc Vdr'' else v2.NDoc end as Ndoc_Vdr,
		v.Cd_Vta
		,case  when isnull(v2.RSocial,'''')='''' then isnull(v2.ApPat,'''') +'' ''+isnull(v2.ApMat,'''')+'' ''+isnull(v2.Nom,'''') else v2.RSocial end as NomVdr
	FROM VENTA V 
		INNER JOIN VENTADET vd on vd.RucE=v.RucE and vd.Cd_Vta=v.Cd_Vta
		left join Vendedor2 as v2 on v.RucE=v2.RucE and v.Cd_Vdr=v2.Cd_Vdr
		inner join Cliente2  as cl on v.RucE=cl.RucE and v.Cd_Clt= cl.Cd_Clt
		left join Producto2  as p on  vd.RucE=p.RucE and vd.Cd_Prod=p.Cd_Prod
		left join Servicio2 as s on  vd.RucE=s.RucE and vd.Cd_Srv=s.Cd_Srv
	Where v.RucE='''+Convert(varchar,@RucE)+'''
		and isnull(V.Ib_Anulado,0)<>1
		and case when isnull('''+Convert(Varchar,isnull(@vendedor,''))+''','''')<> '''' then v.Cd_Vdr else '''' end = isnull('''+Convert(varchar,isnull(@vendedor,''))+''','''') 
		and case when isnull('''+@Area+''','''')<> '''' then v.cd_Area else '''' end = isnull('''+@Area+''','''') 
		and case when Isnull('''+Convert(Varchar,isnull(@Cd_Clt,''))+''','''')<> '''' then v.Cd_Clt else '''' end = Isnull('''+Convert(Varchar,isnull(@Cd_Clt,''))+''','''')
		and v.FecMov between '''+Convert(varchar,@FecIni)+''' and '''+Convert(varchar,@FecFin)+''' --+ '' 23:59:29''
		and case when isnull('''+Convert(varchar,isnull(@Cd_Prod,''))+''','''')<> '''' then vd.Cd_Prod else '''' end = isnull('''+Convert(varchar,isnull(@Cd_Prod,''))+''','''') 
	'
	
exec(
 @Cons1
 +@ConsCC
  +@Cd_CC
 +@mcons1
 +@ConsSC
  +@Cd_SC
 +@mcons2
 +@ConsSS
  +@Cd_SS
 +@mcons3
 )
-----------------------------------------------------------------------------------------------------------------------
--------DETALLE--------------------------------------------------------------------------------------------------------

set @Cons2='
	SELECT 
		'''' as Prdo, '''' as tipdoc , '''' as fecMov, '''' as Doc_Cli , '''' as cliente,
		case when ISNULL(vd.Cd_Prod,'''')<>'''' then vd.Cd_Prod when ISNULL(vd.Cd_Srv,'''')<>'''' then vd.Cd_Srv else ''--'' end as Cd_Prod
		,isnull(p.CodCo1_,isnull(s.CodCo,'''')) as CodCo1_,
		case when ISNULL(vd.Cd_Prod,'''')<>''''then p.Nombre1 when ISNULL(vd.Cd_Srv,'''')<>'''' then s.Nombre else ''--'' end as Descrip,
		vd.Cd_CC, vd.Cd_SC, vd.Cd_SS,  vd.Valor,vd.Cant,vd.IMP,vd.IGV ,
		cast(case when Cd_Mda='''+Convert(varchar,Isnull(@Cd_Mda,''))+
		''' then  v.Total  else case when isnull('''+Convert(varchar,isnull(@Cd_Mda,''))+''','''')=''01'' then v.Total*v.CamMda else  v.Total/v.CamMda end end as decimal(16,2)) as Total		
		, '''' cd_Vdr, '''' Ndoc_Vdr, v.cd_Vta , '''' as NomVdr
	FROM VENTA V 
		INNER JOIN VENTADET vd on vd.RucE=v.RucE and vd.Cd_Vta=v.Cd_Vta
		left join Vendedor2 as v2 on v.RucE=v2.RucE and v.Cd_Vdr=v2.Cd_Vdr
		inner join Cliente2  as cl on v.RucE=cl.RucE and v.Cd_Clt= cl.Cd_Clt
		left join Producto2  as p on  vd.RucE=p.RucE and vd.Cd_Prod=p.Cd_Prod
		left join Servicio2 as s on  vd.RucE=s.RucE and vd.Cd_Srv=s.Cd_Srv
	Where v.RucE='''+Convert(varchar,@RucE)+'''
		and isnull(V.Ib_Anulado,0)<>1
		and case when isnull('''+Convert(Varchar,isnull(@vendedor,''))+''','''')<> '''' then v.Cd_Vdr else '''' end = isnull('''+Convert(varchar,isnull(@vendedor,''))+''','''') 
		and case when isnull('''+@Area+''','''')<> '''' then v.cd_Area else '''' end = isnull('''+@Area+''','''') 
		and case when Isnull('''+Convert(Varchar,isnull(@Cd_Clt,''))+''','''')<> '''' then v.Cd_Clt else '''' end = Isnull('''+Convert(Varchar,isnull(@Cd_Clt,''))+''','''')
		and v.FecMov between '''+Convert(varchar,@FecIni)+''' and '''+Convert(varchar,@FecFin)+''' --+ '' 23:59:29''
		and v.Cd_Vta in (select distinct Cd_Vta from VentaDet where RucE ='''+Convert(varchar,@RucE)+''' and case when isnull('''+Convert(varchar,isnull(@Cd_Prod,''))+''','''')<> '''' then Cd_Prod else '''' end = isnull('''+Convert(varchar,isnull(@Cd_Prod,''))+''','''')  )
		
'

print @Cons2
print @ConsCC
print @Cd_CC
print @mcons1
print @ConsSC
print @Cd_SC
print @mcons2
print @ConsSS
print @Cd_SS
print @mcons3

exec(
 @Cons2
 +@ConsCC
  +@Cd_CC
 +@mcons1
 +@ConsSC
  +@Cd_SC
 +@mcons2
 +@ConsSS
  +@Cd_SS
 +@mcons3)
 
 

	
	if not exists (select top 1 * from VentaDet where RucE=@RucE)
		set @msj = 'No existe movimientos '
	print @msj
	
		
	 --   exec [dbo].[ReporteVentaDetallada] '20514402346','2012','02',null,null,'01/01/2012','31/03/2012',null
	--    exec [dbo].[ReporteVentaDetallada] '11111111111','2011',null,null, '01','2011/02/01' 
	 ------  codigo vendedor, 'VND0003'
	
	
	
	--select IGV,Total from Venta where RucE='20514402346' and Cd_Vta='VT00000014'
	
	
	--<<<<    16/03/12   CUTTI >>>
	
    
    

GO
