SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Rpt_OPPendiente]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@EstadoOP char(1),
@msj varchar(100) output
as
--Detalle del reporte
declare @Consulta1 varchar(4000)
declare @Consulta2 varchar(4000)
declare @Cond1 varchar(200)
declare @Cond2 varchar(200)
set @Cond1=''
set @Cond2=''
if(@EstadoOP='A')
	begin
	set @Cond1=' where OPD.Cant - VD.Cant = 0'
	set @Cond2=' and OPD.Cant - 0 = 0'
	end
else if(@EstadoOP='P')
	begin
	set @Cond1=' where OPD.Cant - VD.Cant > 0'
	set @Cond2=' and OPD.Cant - 0 > 0'
	end
else if(@EstadoOP='O')
	begin
	set @Cond1=' where OPD.Cant - VD.Cant < 0'
	set @Cond2=' and OPD.Cant - 0 < 0'
	end

set @Consulta1='select *from (
select 	OPD.RucE, 
	OPD.Cd_Op, 
	OPD.NroOP, 
	case(isnull(OPD.Cd_Prod,'''')) when '''' then OPD.CD_Srv else OPD.Cd_Prod end as CodProdServ,
	case(isnull(OPD.Cd_Prod,'''')) when '''' then s2.CodCo+'' ''+s2.Nombre else p2.CodCo1_ +'' ''+p2.Nombre1 end as NombProdServ,
	OPD.ID_UMP, 
	OPD.Cd_Clt, 
	CASE(isnull(c2.RSocial,'''')) when ''''  then rtrim(isnull(c2.ApPat,'''')) +'' ''+ rtrim(isnull(c2.ApMat,''''))+'', ''+rtrim(isnull(c2.Nom,'''')) else c2.RSocial end as Cliente,
	OPD.Cd_Vdr,
	CASE(isnull(v2.RSocial,'''')) when ''''  then rtrim(isnull(v2.ApPat,'''')) +'' ''+ rtrim(isnull(v2.ApMat,''''))+'', ''+rtrim(isnull(v2.Nom,'''')) else v2.RSocial end as Vendedor,
	OPD.Cant, 
	VD.Cant as CantVD, 
	OPD.Cant - VD.Cant as Pendiente, 
	case when OPD.Cant - VD.Cant = 0 then ''Atendido'' when OPD.Cant - VD.Cant > 0 then ''Parcialmente Atendido'' else ''Observar'' end as EstadoOP
from (	select 	op.RucE, 
		op.Cd_Op, 
		op.NroOP, 
		opd.Cd_Prod, 
		opd.ID_UMP, 
		opd.Cd_Srv, 
		isnull(opd.Cant,0) cant, 
		op.Cd_Vdr, op.Cd_Clt 
	from 	OrdPedido op 
		inner join OrdPedidoDet opd on opd.RucE=op.RucE and opd.Cd_OP=op.Cd_OP
	where 	op.RucE='''+@RucE+''' 
		and op.FecE between '''+ convert(nvarchar,@FecD,103) +''' and ''' +convert(nvarchar,@FecH,103)+ ''') as OPD inner join 
     (	select 	ve.RucE, 
		ve.Cd_Vta, 
		ve.Eje, 
		ve.Cd_OP, 
		ve.NroOp, 
		vd.Cd_Prod, 
		vd.ID_UMP, 
		vd.Cd_Srv,
		isnull(vd.Cant,0) Cant, 
		ve.Cd_Vdr, 
		ve.Cd_Clt 
	from 	Venta ve 
		inner join VentaDet vd on vd.RucE=ve.RucE and vd.Cd_Vta=ve.Cd_Vta
	where 	ve.RucE='''+@RucE+''' 
		and ve.FecMov between '''+ convert(nvarchar,@FecD,103) +''' and ''' +convert(nvarchar,@FecH,103)+ ''') as VD 
	on VD.RucE=OPD.RucE and VD.Cd_Op=OPD.Cd_Op and (OPD.Cd_Prod=VD.Cd_Prod or VD.Cd_Srv=OPD.Cd_Srv)
	left join Producto2 p2 on p2.RucE=OPD.RucE and p2.Cd_Prod=OPD.Cd_Prod
	left join Servicio2 s2 on s2.RucE=OPD.RucE and s2.Cd_Srv=OPD.Cd_Srv
	inner join Cliente2 c2 on c2.RucE=OPD.RucE and c2.Cd_Clt=OPD.Cd_Clt
	inner join Vendedor2 v2 on v2.RucE=OPD.RucE and v2.Cd_Vdr=OPD.Cd_Vdr
'+@Cond1+') as Pend'
--Consuta 1
print @Consulta1
print len(@Consulta1)
--Consulta 2
set @Consulta2=' union all
select *from(
select 	op.RucE, 
	op.Cd_Op, 
	op.NroOP, 
	case(isnull(opd.Cd_Prod,'''')) when '''' then opd.CD_Srv else opd.Cd_Prod end as CodProdServ,
	case(isnull(opd.Cd_Prod,'''')) when '''' then s2.CodCo+'' ''+s2.Nombre else p2.CodCo1_ +'' ''+p2.Nombre1 end as NombProdServ,
	opd.ID_UMP, 
	op.Cd_Clt, 
	CASE(isnull(c2.RSocial,'''')) when ''''  then rtrim(isnull(c2.ApPat,'''')) +'' ''+ rtrim(isnull(c2.ApMat,''''))+'', ''+rtrim(isnull(c2.Nom,'''')) else c2.RSocial end as Cliente,
	op.Cd_Vdr,
	CASE(isnull(v2.RSocial,'''')) when ''''  then rtrim(isnull(v2.ApPat,'''')) +'' ''+ rtrim(isnull(v2.ApMat,''''))+'', ''+rtrim(isnull(v2.Nom,'''')) else v2.RSocial end as Vendedor,
	isnull(opd.Cant,0) cant, 
	0.00 CantVd, isnull(opd.Cant,0) Pendiente, ''No Atendido'' EstadoOP
from OrdPedido op 
	inner join OrdPedidoDet opd on opd.RucE=op.RucE and opd.Cd_OP=op.Cd_OP 
	left join Producto2 p2 on p2.RucE=opd.RucE and p2.Cd_Prod=opd.Cd_Prod
	left join Servicio2 s2 on s2.RucE=opd.RucE and s2.Cd_Srv=opd.Cd_Srv
	inner join Cliente2 c2 on c2.RucE=op.RucE and c2.Cd_Clt=op.Cd_Clt
	inner join Vendedor2 v2 on v2.RucE=op.RucE and v2.Cd_Vdr=op.Cd_Vdr
	where op.RucE='''+@RucE+''' and op.FecE between '''+ convert(nvarchar,@FecD,103) +''' and ''' +convert(nvarchar,@FecH,103)+ ''' and op.Cd_OP not in(select isnull(Cd_Op,'''') from Venta where RucE='''+@RucE+''')
'+@Cond2+
') as NoAtend'

print @Consulta2
print len(@Consulta2)


--Exec Consultas
exec (@Consulta1+@Consulta2)
--Cabecera
select @RucE RucE, RSocial, 'Del ' + Convert(nvarchar,@FecD,103) +' al '+ Convert(nvarchar,@FecH,103) Prdo from Empresa where Ruc=@RucE

--sentencias para actualizar venta y orden de pedido
/*
declare @RucE nvarchar(11)
set @RucE='20536756541'
--update venta set Cd_OP='OP00000003' where RucE=@RucE  and Cd_Vta='VT00000006'
update venta set Cd_Vdr='VND0001' where RucE=@RucE  and Cd_Vta='VT00000006'

sp_help ordpedido
Exec Rpt_OPPendiente '20536756541','01/02/2010','28/03/2011','P',null
@FecD datetime,
@FecH datetime,
@EstadoOP char(1),
*/

-- Leyenda --
-- JJ : 2011-02-04 : <Creacion del procedimiento almacenado>
-- JJ : 2011-02-05 : <Modificacion del  procedimiento almacenado. se agregaron filtros para Atendidas,Pendietnes, en observacion y todos>
-- FL : 2011-02-05 : <Modificacion del  procedimiento almacenado. se agregaron filtros de fechas>
-- JJ : 2011-02-05 : <Modificacion del  procedimiento almacenado. se agregaro Campo de estado de la OP>






GO
