SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Consultar_Saldos_SC]
@RucE varchar(11),
@Cd_SC char(10),
@TipoDet int,
@msj varchar(100) output
as

if not exists (select * from SolicitudComDet where RucE = @RucE and Cd_SC = @Cd_SC)
begin
	set @msj = 'La solicitud de compra con codigo ' + @Cd_SC + ' no existe.'
	return
end
if(@TipoDet = 0) -- SOLO PRODUCTOS
begin
	select  t1.Cd_Prod as 'Cd_Det', pd.Nombre1 as 'Nombre', pd.Descrip as 'Descripcion', 
				t1.ID_UMP, pum.DescripAlt as 'UnidadMedida', 
				sum(case when(Cant<0) then 0 else Cant end) as 'Total',  sum(Cant) as 'Saldo'
	from (
		select Cd_Prod, isnull(Cant,0) as 'Cant', ID_UMP from SolicitudComDet
		where RucE = @RucE and Cd_SC = @Cd_SC and Cd_Prod is not null
		union all
		select Cd_Prod, isnull(-Cant,0) as 'Cant', ID_UMP from OrdCompraDet
		where RucE = @RucE and Cd_SCo = @Cd_SC and Cd_Prod is not null
	) as t1
	join Producto2 pd on pd.RucE = @RucE and pd.Cd_Prod = t1.Cd_Prod
	left join Prod_UM pum on pum.RucE = @RucE and pum.Cd_Prod = t1.Cd_Prod and pum.ID_UMP = t1.ID_UMP
	group by t1.Cd_Prod, t1.ID_UMP, pd.Nombre1, pd.Descrip, pum.DescripAlt
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
		select t1.Cd_SRV, sum(case when (Cant<0) then 0 else Cant end) as 'Total', sum(Cant) as 'Saldo'
		from(	
			select Cd_Srv, isnull(Cant,0) as Cant
			from SolicitudComDet where RucE = @RucE and Cd_SC = @Cd_SC
			union all
			select Cd_Srv, isnull(-Cant,0) as Cant
			from OrdCompraDet where RucE = @RucE and Cd_SCo = @Cd_SC
		) as t1
		group by t1.Cd_SRV
	) as t2
	
	select  scd.Cd_SRV as 'Cd_Det', sr.Nombre as 'Nombre', sr.Descrip as 'Descripcion', 
			t1.Total as 'Total',  t1.Saldo as 'Saldo', IB_AtSrv
	from SolicitudComDet scd
	join @tablaS t1 on t1.Cd_Srv = scd.Cd_SRV
	join Servicio2 sr on sr.RucE = @RucE and sr.Cd_Srv = scd.Cd_SRV
	where scd.RucE = @RucE and scd.Cd_SC = @Cd_SC
	
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
	select * from (
		select Cd_Prod, Cd_Srv, ID_UMP, sum(case when (Cant<0) then 0 else Cant end) as 'Total', sum(Cant) as 'Saldo'
		from(	
			select RucE, Cd_Prod, isnull(Cant,0) as Cant, ID_UMP, Cd_Srv, isnull(IB_AtSrv,0) as IB_AtSrv
			from SolicitudComDet where RucE = @RucE and Cd_SC = @Cd_SC
			union all
			select RucE, Cd_Prod, isnull(-Cant,0) as Cant, ID_UMP, Cd_Srv, isnull(IB_AtSrv,0) as IB_AtSrv
			from OrdCompraDet where RucE = @RucE and Cd_SCo = @Cd_SC
		) as t1
		group by RucE, Cd_Prod, ID_UMP, Cd_Srv
	) as t2

	select isnull(scd.Cd_Prod, scd.Cd_SRV) as Cd_Det, ISNULL(pr.Nombre1, ISNULL(sr.Nombre,'')) as 'Nombre',
	isnull(sr.Descrip, pr.Descrip) as 'Descripcion', isnull(pum.DescripAlt, '------') as 'UnidadMedida',
	ISNULL(scd.ID_UMP, 0) as UMP, ISNULL(t1.Total, t2.Total) as 'Total', isnull(t1.Saldo, t2.Saldo) as 'Saldo', 
	case when (scd.Cd_SRV is not null) then 1 else 0 end as 'EsServicio', isnull(IB_AtSrv,0) as IB_AtSrv

	from SolicitudComDet scd
	left join @tabla as t1 on scd.Cd_Prod = t1.Cd_Prod
	left join @tabla as t2 on scd.Cd_SRV = t2.Cd_Srv

	left join Producto2 pr on pr.RucE = @RucE and pr.Cd_Prod = scd.Cd_Prod
	left join Servicio2 sr on sr.RucE = @RucE and sr.Cd_Srv = scd.Cd_SRV
	left join Prod_UM pum on pum.RucE = @RucE and pum.Cd_Prod = scd.Cd_Prod and pum.ID_UMP = scd.ID_UMP
	where scd.RucE = @RucE and scd.Cd_SC = @Cd_SC
end

--	LEYENDA
/*	MM : <30/07/11 : Creacion del SP>
	
*/
--	PRUEBAS
/*	exec Inv_Consultar_Saldos_SC '11111111111','SC00000156',0,null
	exec Inv_Consultar_Saldos_SC '11111111111','SC00000156',1,null
	exec Inv_Consultar_Saldos_SC '11111111111','SC00000156',2,null
*/
GO
