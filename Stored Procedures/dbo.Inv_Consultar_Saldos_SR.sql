SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_Consultar_Saldos_SR]
@RucE varchar(11),
@Cd_SR char(10),
@TipoDet int,
@msj varchar(100) output
as
set @msj = ''
if not exists (select * from SolicitudReq where RucE = @RucE and Cd_SR = @Cd_SR)
begin
	set @msj = 'La solicitud de requerimientos con codigo ' + @Cd_SR + ' no existe.'
	return
end
if(@TipoDet = 0) -- SOLO PRODUCTOS
begin
	declare @tablaProd table
	(
		Cd_Prod char (7),	
		ID_UMP int,
		Total numeric(13,3),
		Saldo numeric(13,3)
	)
	insert into @tablaProd
	select Cd_Prod, ID_UMP, sum(case when (Cant<0) then 0 else Cant end) as 'Total', sum(Cant) as 'Saldo'
	from(
		select Cd_Prod, isnull(Cant,0) as Cant, ID_UMP
		from SolicitudReqDet where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Prod is not null
		union all
		select Cd_Prod, isnull(-Cant,0) as Cant, ID_UMP
		from SolicitudComDet where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Prod is not null
		union all
		select Cd_Prod, isnull(Cant_Ing,0) as Cant, ID_UMP
		from Inventario where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Prod is not null
	) as t1
	group by t1.Cd_Prod, t1.ID_UMP

	select	sr.NroSR, t1.Cd_Prod as 'Cd_Det', pd.Nombre1 as 'Nombre', pd.Descrip as 'Descripcion', 
			t1.ID_UMP, pu.DescripAlt as 'UnidadMedida', srd.Cant as 'Total', t1.Saldo,
			convert(int,case(pc.Cd_ProdB) when srd.cd_Prod then '1' else '0' end) as EsGrupo, pu.Factor
	from SolicitudReq sr
	join SolicitudReqDet srd on srd.RucE = sr.RucE and srd.Cd_SR = sr.Cd_SR
	join @tablaProd t1 on t1.Cd_Prod = srd.Cd_Prod and t1.ID_UMP = srd.ID_UMP
	join Producto2 pd on pd.RucE = srd.RucE and pd.Cd_Prod = t1.Cd_Prod
	left join Prod_UM pu on pu.RucE = srd.RucE and pu.Cd_Prod = t1.Cd_Prod and pu.ID_UMP = t1.ID_UMP
	left join ProdCombo pc on pc.RucE = srd.RucE and t1.Cd_Prod = pc.Cd_ProdB and pc.ID_UMP = t1.ID_UMP
	where sr.RucE = @RucE and sr.Cd_SR = @Cd_SR
end
else if(@TipoDet = 1) -- SOLO SERVICIOS
begin
	declare @tablaS table
	(
		Cd_Srv char (7),
		Total numeric(13,3),
		Saldo numeric(13,3)
	)
	insert into @tablaS
	select * from (
		select  t1.Cd_Srv, sum(case when(Cant<0) then 0 else Cant end) as 'Total',  sum(Cant) as 'Saldo'				
		from (
			select Cd_Srv, isnull(Cant,0) as Cant
			from SolicitudReqDet where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Srv is not null
			union all
			select Cd_Srv, isnull(-Cant,0) as Cant
			from SolicitudComDet where RucE = @RucE and Cd_SR = @Cd_SR and Cd_Srv is not null	
		) as t1	
		group by t1.Cd_Srv
	) as t2

	select  srd.Cd_SRV as 'Cd_Det', sr.Nombre as 'Nombre', sr.Descrip as 'Descripcion', 
			t1.Total as 'Total',  t1.Saldo as 'Saldo', IB_AtSrv, case when (sr.Cd_Srv is not null) then 1 else 0 end as 'EsServicio'
	from SolicitudReqDet srd
	join @tablaS t1 on t1.Cd_Srv = srd.Cd_SRV
	join Servicio2 sr on sr.RucE = @RucE and sr.Cd_Srv = srd.Cd_SRV
	where srd.RucE = @RucE and srd.Cd_SR = @Cd_SR
end
else if(@TipoDet = 2) -- PRODUCTOS Y SERVICIOS
begin
	declare @tabla table
	(
		Cd_Prod char (7),
		Cd_Srv char (7),
		ID_UMP int,
		Total numeric(13,3),
		Saldo numeric(13,3)
	)

	insert into @tabla 
	select * from(
		select Cd_Prod, Cd_Srv, ID_UMP, sum(case when (Cant<0) then 0 else Cant end) as 'Total', sum(Cant) as 'Saldo'
		from (
		
			select RucE, Cd_Prod, isnull(Cant,0) as Cant, ID_UMP, Cd_Srv
			from SolicitudReqDet where RucE = @RucE and Cd_SR = @Cd_SR
			union all
			select RucE, Cd_Prod, isnull(-Cant,0) as Cant, ID_UMP, Cd_Srv
			from SolicitudComDet where RucE = @RucE and Cd_SR = @Cd_SR
			union all
			select RucE, Cd_Prod, isnull(Cant_Ing,0) as Cant, ID_UMP, null as Cd_Srv
			from Inventario where RucE = @RucE and Cd_SR = @Cd_SR		
		) as t1
		group by RucE, Cd_Prod, ID_UMP, Cd_Srv
	) as t2

	select isnull(srd.Cd_Prod, srd.Cd_Srv) as 'Cd_Det', isnull(sr.Nombre, isnull(pr.Nombre1,'')) as 'Nombre',
	isnull(sr.Descrip, pr.Descrip) as 'Descripcion' ,isnull(srd.ID_UMP,0) as ID_UMP, isnull(pum.DescripAlt, '------') as 'UnidadMedida', 
	isnull(t1.Total, t2.Total) as 'Total', isnull(t1.Saldo, t2.Saldo) as 'Saldo',
	case when (srd.Cd_Srv is not null) then 1 else 0 end as 'EsServicio', isnull(IB_AtSrv,0) as IB_AtSrv

	from SolicitudReqDet srd
	left join @tabla as t1 on srd.Cd_Srv = t1.Cd_Srv
	left join @tabla as t2 on srd.Cd_Prod = t2.Cd_Prod

	left join Producto2 pr on pr.RucE = @RucE and pr.Cd_Prod = srd.Cd_Prod
	left join Servicio2 sr on sr.RucE = @RucE and sr.Cd_Srv = srd.Cd_Srv
	left join Prod_UM pum on pum.RucE = @RucE and pum.Cd_Prod = srd.Cd_Prod and pum.ID_UMP = srd.ID_UMP
	where srd.RucE = @RucE and srd.Cd_SR = @Cd_SR
end


--	LEYENDA
/*	MM : <26/07/11 : Creacion del SP>
	MM : <27/07/11 : Modificación del SP - Se agrego busqueda por servicios>
*/
--	PRUEBAS
/*	exec Inv_Consultar_Saldos_SR '11111111111','SR00000169',0,null
	exec Inv_Consultar_Saldos_SR '11111111111','SR00000169',1,null
	exec Inv_Consultar_Saldos_SR '11111111111','SR00000169',2,null
*/

GO
