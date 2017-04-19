SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Rpt_SRPendientes]
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
	set @Cond1=' and isnull(SR.Cant,0) - isnull(SC.Cant,0) > 0'
	set @Cond2=' and isnull(SRD.Cant,0) -0 > 0'
end
else if(@EstadoOC='S')
begin
	set @Cond1=' and isnull(SR.Cant,0) - isnull(SC.Cant,0) = 0'
	set @Cond2=' and isnull(SRD.Cant,0) -0 = 0'
end
else if(@EstadoOC='O')
begin
	set @Cond1=' and isnull(SR.Cant,0) - isnull(SC.Cant,0) < 0'
	set @Cond2=' and isnull(SRD.Cant,0) -0 < 0'
end

-- Detalles   sr.FecEmi sc.FecEmi
set @Consulta1='Select Con3.*,p2.Nombre1 as Producto from(
select * from (
select 	SR.RucE,SR.Cd_Sr,SR.NroSr,SR.Cd_Prod,SR.ID_UMP,SR.Cant CantSR,
	SC.Cant CantSC, case when SR.Cant-SC.Cant < 0 then ''Excedio'' when SR.Cant-SC.Cant = 0 then ''Completado'' when SR.Cant-SC.Cant > 0 then ''Pendiente'' end as Estado,
	SR.Cant-SC.Cant as Pendiente from(
select sr.RucE,sr.Cd_Sr,sr.NroSr,srd.Cd_Prod,srd.ID_UMP,srd.Cant
from 
	SolicitudReq sr	inner join SolicitudReqDet srd on
	srd.RucE=sr.RucE and srd.Cd_SR=sr.Cd_SR
where sr.RucE='''+@RucE+''' and sr.FecEmi between '''+convert(nvarchar,@FecD,103)+ ''' and '''+convert(nvarchar,@FecH,103)+'''
) as SR inner join (
select 
	sc.RucE,sc.Cd_SCo,sc.NroSC,sc.Cd_SR,scd.Cd_Prod,scd.ID_UMP,
	scd.Cant
from 
	SolicitudCom sc inner join SolicitudComDet scd on
	scd.RucE=sc.RucE and scd.Cd_SC=sc.Cd_SCo
where sc.RucE='''+@RucE+''' and sc.FecEmi between '''+convert(nvarchar,@FecD,103)+ ''' and '''+convert(nvarchar,@FecH,103)+'''
	and sc.Cd_SR is not null
) as SC on SC.RucE=SR.RucE and SC.Cd_SR=SR.Cd_SR and SC.Cd_Prod=SR.Cd_Prod
'+@Cond1+') as Con1'
set @Consulta2=' UNION ALL
select *from(
select 	SR.RucE,SR.Cd_Sr,SR.NroSr,SR.Cd_Prod,SR.ID_UMP,SR.Cant CantSR,
	0.00 CantSC, ''No Atendidas'' as Estado,
	SR.Cant as Pendiente from(
select sr.RucE,sr.Cd_Sr,sr.NroSr,srd.Cd_Prod,srd.ID_UMP,srd.Cant
from 
	SolicitudReq sr	inner join SolicitudReqDet srd on
	srd.RucE=sr.RucE and srd.Cd_SR=sr.Cd_SR
where sr.RucE='''+@RucE+''' and sr.FecEmi between '''+convert(nvarchar,@FecD,103)+ ''' and '''+convert(nvarchar,@FecH,103)+'''
and sr.Cd_Sr not in(Select Cd_Sr from SolicitudCom where RucE='''+@RucE+''' and Cd_Sr is not null)
'+@Cond2+')  as SR
) as Con2) as Con3 inner join Producto2 p2 on p2.RucE=Con3.RucE and p2.Cd_Prod=Con3.Cd_Prod'
print @Consulta1
print @Consulta2
exec(@Consulta1+@Consulta2)

--Cabeceras
select @RucE RucE, RSocial, 'Del ' + Convert(nvarchar,@FecD,103) +' al '+ Convert(nvarchar,@FecH,103) Prdo from Empresa where Ruc=@RucE



--exec Rpt_SRPendientes '11111111111','01/01/2010','31/12/2011','S',null
--exec Rpt_SRPendientes '11111111111','01/01/2011','31/12/2011','P',null
--exec Rpt_SRPendientes '11111111111','01/01/2011','31/12/2011','O',null
--exec Rpt_SRPendientes '11111111111','01/01/2011','31/12/2011','Z',null

-- Leyenda --
-- JJ : 2011-03-17 : <Creacion del procedimiento almacenado>


GO
