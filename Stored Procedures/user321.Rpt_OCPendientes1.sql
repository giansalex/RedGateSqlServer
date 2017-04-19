SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Rpt_OCPendientes1]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@EstadoOC char(1),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@msj varchar(100) output
as


declare @Cond1 varchar(200) set @Cond1=''
declare @Cond2 varchar(200) set @Cond2=''
declare @Cond3 varchar(200) set @Cond3=''
declare @Cond4 varchar(200) set @Cond4=''
declare @Consulta1 varchar(4000)
declare @Consulta2 varchar(4000)

if(@Cd_CC='' and @Cd_SC='' and @Cd_SS='' or @Cd_CC is null and @Cd_SC is null and @Cd_SS is null)
begin
	set @Cond3=''
	set @Cond4=''
end
else if(@Cd_SC='' and @Cd_SS='' or @Cd_SC is null and @Cd_SS is null)
begin 
		set @Cond3=' and oc.Cd_CC='''+@Cd_CC+''''
		set @Cond4=' and co.Cd_CC='''+@Cd_CC+''''
end
else if(@Cd_SS='' or @Cd_SS is null)
begin
		set @Cond3=' and oc.Cd_CC='''+@Cd_CC+''' and oc.Cd_SC='''+@Cd_SC+''''
		set @Cond4=' and co.Cd_CC='''+@Cd_CC+''' and co.Cd_SC='''+@Cd_SC+''''
end
else
begin
		set @Cond3=' and oc.Cd_CC='''+@Cd_CC+''' and oc.Cd_SC='''+@Cd_SC+''' and oc.Cd_SS='''+@Cd_SS+''''
		set @Cond4=' and co.Cd_CC='''+@Cd_CC+''' and co.Cd_SC='''+@Cd_SC+''' and co.Cd_SS='''+@Cd_SS+''''
end
if(@EstadoOC='P')
begin
	set @Cond1=' and isnull(OCD.Cant,0) - isnull(COM.Cant,0) > 0'
	set @Cond2=' and isnull(ocd.Cant,0) -0 > 0'
end
else if(@EstadoOC='C')
begin
	set @Cond1=' and isnull(OCD.Cant,0) - isnull(COM.Cant,0) = 0'
	set @Cond2=' and isnull(ocd.Cant,0) -0 = 0'
end
else if(@EstadoOC='O')
begin
	set @Cond1=' and isnull(OCD.Cant,0) - isnull(COM.Cant,0) < 0'
	set @Cond2=' and isnull(ocd.Cant,0) -0 < 0'
end


set @Consulta1='select *from (select *from(
select OCD.RucE, OCD.Cd_OC, OCD.NroOC, case(isnull(OCD.Cd_Prod,'''')) when '''' then OCD.Cd_Srv else OCD.Cd_Prod end as CodProdServ,
	case(isnull(OCD.Cd_Prod,'''')) when '''' then rtrim(ltrim(isnull(s2.CodCo,'''')+'' ''+isnull(s2.Nombre,''''))) else rtrim(ltrim(isnull(p2.CodCo1_,'''')+'' ''+isnull(p2.Nombre1,''''))) end as NombProdServ,
	OCD.ID_UMP, OCD.Cd_Prv, case(isnull(pr.RSocial,'''')) when '''' then rtrim(isnull(pr.ApPat,'''')) + '' ''+rtrim(isnull(pr.ApMat,''''))+'', ''+rtrim(isnull(pr.Nom,'''')) else pr.RSocial end as Proveedor,
	isnull(OCD.Cant,0) CantOC, isnull(COM.Cant,0) CantCO, isnull(OCD.Cant,0) - isnull(COM.Cant,0) CantACom, OCD.PU as PU_OC, OCD.Total as Total_OC, COM.Total as Total_CO, OCD.Total - COM.Total as TotFal, 
	case when isnull(OCD.Cant,0) - isnull(COM.Cant,0) = 0 then ''Completadas'' when isnull(OCD.Cant,0) - isnull(COM.Cant,0) > 0  then ''Parcialmente Atendido'' when isnull(OCD.Cant,0) - isnull(COM.Cant,0) < 0 then ''Observacion'' end as Atend,
	COM.RegCtb,Com.Factura,COM.Cd_CC,COM.Cd_SC,COM.Cd_SS
from (select oc.RucE, oc.Cd_OC, oc.NroOC, ocd.Cd_Prod, ocd.ID_UMP, ocd.Cd_Srv,
	isnull(ocd.Cant,0) Cant, oc.Cd_Prv,ocd.PU, ocd.Total from OrdCompra oc
	inner join OrdCompraDet ocd on ocd.RucE=oc.RucE and ocd.Cd_OC=oc.Cd_OC 
where oc.RucE='''+@RucE+''' and oc.FecE between '''+convert(nvarchar,@FecD,103)+ ''' and '''+convert(nvarchar,@FecH,103)+''''+@Cond3+') as OCD 
inner join (select  co.RucE, co.Cd_Com,co.Ejer, co.Cd_OC, cd.Cd_Prod, cd.ID_UMP, cd.Cd_Srv, 
	isnull(cd.Cant,0) Cant, co.Cd_Prv, cd.Total,co.RegCtb,co.NroSre +''-''+ co.NroDoc Factura,
	co.Cd_CC,co.Cd_SC,co.Cd_SS
from Compra co inner join CompraDet cd on cd.RucE=co.RucE and cd.Cd_Com=co.Cd_Com
where co.RucE='''+@RucE+''' and FecMov between '''+convert(nvarchar,@FecD,103)+ ''' and '''+convert(nvarchar,@FecH,103)+''''+@Cond4+') as COM  on COM.RucE=OCD.RucE and COM.Cd_OC=OCD.Cd_OC and (COM.Cd_Prod=OCD.Cd_Prod or COM.Cd_Srv=OCD.Cd_Srv)
	left join Producto2 p2 on p2.RucE=OCD.RucE and p2.Cd_Prod=OCD.Cd_Prod
	left join Servicio2 s2 on s2.RucE=OCD.RucE and s2.Cd_Srv=OCD.Cd_Srv
	inner join Proveedor2 pr on pr.RucE=OCD.RucE and pr.Cd_Prv=OCD.Cd_Prv
'+@Cond1+') as Com'
set @Consulta2=' union all select * from(
select 	oc.RucE, oc.Cd_OC, oc.NroOC, case(isnull(ocd.Cd_Prod,'''')) when '''' then ocd.Cd_Srv else ocd.Cd_Prod end as CodProdServ,
	case(isnull(ocd.Cd_prod,'''')) when '''' then rtrim(ltrim(isnull(s2.CodCo,'''')+'' ''+isnull(s2.Nombre,''''))) else rtrim(ltrim(isnull(p2.CodCo1_,'''') +'' ''+isnull(p2.Nombre1,''''))) end as NombProdServ,
	ocd.ID_UMP,oc.Cd_Prv,case(isnull(pr.RSocial,'''')) when '''' then rtrim(isnull(pr.ApPat,'''')) + '' ''+rtrim(isnull(pr.ApMat,''''))+'', ''+rtrim(isnull(pr.Nom,'''')) else pr.RSocial end as Proveedor,
	isnull(ocd.Cant,0) CantOC, 0.00 as CantCO, isnull(ocd.Cant,0) -0 as CantACom, ocd.PU as PU_OC,ocd.Total as Total_OC, 0 as Total_CO, ocd.Total - 0 as TotFal, ''No Atendida'' as Atend,
	''Sin Reg. Ctb'' RegCtb, ''Sin Factura'' as Factura,oc.Cd_CC,oc.Cd_SC,oc.Cd_SS
from 	OrdCompra oc inner join OrdCompraDet ocd on ocd.RucE=oc.RucE and ocd.Cd_OC=oc.Cd_OC 
	left join producto2 p2 on p2.RucE=ocd.RucE and p2.Cd_Prod=ocd.Cd_Prod
	left join Servicio2 s2 on s2.RucE=ocd.RucE and s2.Cd_Srv=ocd.Cd_Srv
	inner join Proveedor2 pr on pr.RucE=OCD.RucE and pr.Cd_Prv=oc.Cd_Prv
where oc.Cd_OC not in (select Cd_OC from Compra where Cd_OC is not null and RucE='''+@RucE+''' and FecMov between '''+convert(nvarchar,@FecD,103)+ ''' and '''+convert(nvarchar,@FecH,103)+''') and oc.RucE='''+@RucE+''' and oc.FecE between '''+convert(nvarchar,@FecD,103)+ ''' and '''+convert(nvarchar,@FecH,103)+'''
'+@Cond2+@Cond3+'
) as pend) as Rpt 
order by Cd_OC, CodProdServ, Cd_Prv, Atend'
print @Consulta1
print @Consulta2
exec (@Consulta1+@Consulta2)

select @RucE RucE, RSocial, 'Del ' + Convert(nvarchar,@FecD,103) +' al '+ Convert(nvarchar,@FecH,103) Prdo from Empresa where Ruc=@RucE

--exec Rpt_OCPendientes1 '20504743561','01/01/2011','31/12/2011','C','TELE','0001','119002',null
--exec Rpt_OCPendientes1 '11111111111','01/01/2011','31/12/2011','P',null,null,null,null
--exec Rpt_OCPendientes1 '11111111111','01/01/2011','31/12/2011','O',null,null,null,null
--exec Rpt_OCPendientes1 '11111111111','01/01/2011','31/12/2011','Z',null,null,null,null

-- Leyenda --
-- JJ : 2011-02-07 : <Creacion del procedimiento almacenado>
-- JJ : 2011-02-07 : <Modificacion del  procedimiento almacenado. se agregaron filtros para Atendidas,Pendietnes, en observacion y todos>
-- FL : 2011-02-07 : <Modificacion del  procedimiento almacenado. se agregaron filtros de fechas>
-- JJ : 2011-02-07 : <Modificacion del  procedimiento almacenado. se agregaro Campo de estado de la OP>


GO
