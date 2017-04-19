SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Rpt_SCPendientes]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@EstadoOC char(1),
@msj varchar(100) output
as



declare @Consulta1 varchar(4000) declare @Consulta2 varchar(4000)

declare @Cond1 varchar(200) set @Cond1=''
declare @Cond2 varchar(200) set @Cond2=''

if(@EstadoOC='P')
begin
	set @Cond1=' and isnull(SC.Cant,0) - isnull(OC.Cant,0) > 0'
	set @Cond2=' and isnull(SCD.Cant,0) -0 > 0'
end
else if(@EstadoOC='S')
begin
	set @Cond1=' and isnull(SC.Cant,0) - isnull(OC.Cant,0) = 0'
	set @Cond2=' and isnull(SCD.Cant,0) -0 = 0'
end
else if(@EstadoOC='O')
begin
	set @Cond1=' and isnull(SC.Cant,0) - isnull(OC.Cant,0) < 0'
	set @Cond2=' and isnull(SCD.Cant,0) -0 < 0'
end
--Detalle
set @Consulta1='
select *from(
select 	SC.RucE,SC.Cd_SCo,SC.NroSC,OC.Cd_OC,
	SC.Cd_FPC,SC.Cd_Prod,p2.Nombre1 as Producto, SC.ID_UMP,OC.Cd_Prv,
	case(isnull(pr.RSocial,'''')) when '''' then rtrim(isnull(pr.ApPat,'''')) + '' ''+rtrim(isnull(pr.ApMat,''''))+'', ''+rtrim(isnull(pr.Nom,'''')) else pr.RSocial end as Proveedor,
	SC.Cant CantSC,OC.Cant CantOC, 
	case when SC.Cant - OC.Cant < 0 then ''Excedio'' when SC.Cant - OC.Cant = 0 then ''Completado'' when SC.Cant - OC.Cant > 0 then ''Pendiente'' end as Estado,
	SC.Cant - OC.Cant as Pendiente
	from(
	select 
		sc.RucE,
		sc.Cd_SCo,
		sc.NroSC, 
		sc.Cd_FPC,
		scd.Cd_Prod,
		scd.ID_UMP,
		scd.Cant
	from 	
		SolicitudCom sc inner join SolicitudComDet scd on
		scd.RucE=sc.RucE and scd.Cd_SC=sc.Cd_SCo
	where sc.RucE='''+@RucE+''' and sc.FecEmi between '''+convert(nvarchar,@FecD,103)+ ''' and '''+convert(nvarchar,@FecH,103)+'''
	) as SC 
	inner join (
	select
		oc.RucE,
		oc.Cd_OC,
		oc.Cd_SCo,
		oc.Cd_FPC,
		ocd.Cd_Prod,
		ocd.ID_UMP,
		ocd.Cant,
		oc.Cd_Prv
	from 
		OrdCompra oc inner join OrdCompraDet ocd on
		ocd.RucE=oc.RucE and ocd.Cd_OC=oc.Cd_OC 
	where 	oc.RucE='''+@RucE+''' and ocd.Cd_Srv is null and oc.Cd_SCo is not null
	and oc.FecE between '''+convert(nvarchar,@FecD,103)+ ''' and '''+convert(nvarchar,@FecH,103)+'''
	) as OC on OC.RucE=SC.RucE and OC.Cd_SCo=SC.Cd_SCo and OC.Cd_Prod=SC.Cd_Prod
	inner join Producto2 p2 on p2.RucE=SC.RucE and p2.Cd_Prod=SC.Cd_Prod
	inner join Proveedor2 pr on pr.RucE=oc.RucE and pr.Cd_Prv=oc.Cd_Prv
	'+@Cond1+'
	) as con1
'

set @Consulta2=' UNION ALL
Select *from(
select 
	sc.RucE,
	sc.Cd_SCo,
	sc.NroSC,
	'''' as Cd_OC,
	sc.Cd_FPC,
	scd.Cd_Prod,
	p2.Nombre1 as Producto,
	scd.ID_UMP,
	'''' Cd_Prv,
	'''' Proveedor,
	scd.Cant as CantSC,
	0.00 as CantOC,
	''No Atendidas'' as Estado,
	scd.Cant as Pendiente
from 	
	SolicitudCom sc inner join SolicitudComDet scd on
	scd.RucE=sc.RucE and scd.Cd_SC=sc.Cd_SCo
	inner join Producto2 p2 on p2.RucE=scd.RucE and p2.Cd_Prod=scd.Cd_Prod
where 	sc.RucE='''+@RucE+''' and sc.FecEmi between '''+convert(nvarchar,@FecD,103)+ ''' and '''+convert(nvarchar,@FecH,103)+'''
	and sc.Cd_SCo not in(select Cd_SCo from OrdCompra where RucE='''+@RucE+''' and Cd_SCo is not null)
'+@Cond2+') as con2'


print @Consulta1
print @Consulta2
exec(@Consulta1+@Consulta2)

--Cabeceras
select @RucE RucE, RSocial, 'Del ' + Convert(nvarchar,@FecD,103) +' al '+ Convert(nvarchar,@FecH,103) Prdo from Empresa where Ruc=@RucE



--exec Rpt_SCPendientes '11111111111','01/01/2011','31/12/2011','S',null
--exec Rpt_SCPendientes '11111111111','01/01/2011','31/12/2011','P',null
--exec Rpt_SCPendientes '11111111111','01/01/2011','31/12/2011','O',null
--exec Rpt_SCPendientes '11111111111','01/01/2011','31/12/2011','Z',null

-- Leyenda --
-- JJ : 2011-03-17 : <Creacion del procedimiento almacenado>
GO
