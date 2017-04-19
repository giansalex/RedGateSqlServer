SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Consultar_Saldos_OC]
@RucE varchar(11),
@Cd_OC char(10),
@TipoDet int,
@msj varchar(100) output
as
if not exists (select * from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC)
begin
	set @msj = 'La orden de compra con codigo ' + @Cd_OC + ' no existe.'
	return
end
if(@TipoDet = 0) -- SOLO PRODUCTOS
begin
	select	ocd.Item, ocd.Cd_Prod as 'Cd_Det', pd.Nombre1 as 'Nombre', pd.Descrip as 'Descripcion' , pum.ID_UMP, 
			pum.DescripAlt as 'UnidadMedida', ocd.PU, t2.Total as 'TotalC', t2.Saldo, ocd.BIM as 'IMP', ocd.IGV, 
			case(isnull(ocd.IGV,0)) when 0 then 0 else 1 end as 'IncIGV', ocd.Total, ocd.Cd_Alm,
			oc.Cd_CC, oc.Cd_SC, oc.Cd_SS, ocd.Obs, ocd.CA01, ocd.CA02, ocd.CA03, ocd.CA04, ocd.CA05
	from (
		select RucE, Cd_Prod, sum(case when (Cant<0) then 0 else Cant end) as 'Total', sum(Cant) as 'Saldo', Item
		from (
			select RucE, Cd_Prod, Cant, Item from OrdCompraDet
			where RucE = @RucE and Cd_OC = @Cd_OC and Cd_Prod is not null
			union all
			select cp.RucE, Cd_Prod, -Cant, ItemOC from Compra cp
			join CompraDet cpd on cpd.RucE = cp.RucE and cpd.Cd_Com = cp.Cd_Com
			where cp.RucE = @RucE and Cd_OC = @Cd_OC and Cd_Prod is not null and ItemOC is not null
		) as t1
		group by RucE, Cd_Prod, Item
	) as t2
	join OrdCompraDet ocd on ocd.RucE = t2.RucE and ocd.Cd_Prod = t2.Cd_Prod and ocd.Item = t2.Item
	join Producto2 pd on pd.RucE = t2.RucE and pd.Cd_Prod = t2.Cd_Prod 
	left join Prod_UM pum on pum.RucE = t2.RucE and pum.Cd_Prod = pd.Cd_Prod and pum.ID_UMP = ocd.ID_UMP
	join OrdCompra oc on oc.RucE = @RucE and oc.Cd_OC = @Cd_OC
	where ocd.Cd_OC = @Cd_OC and ocd.Cd_Prod is not null
end
else if(@TipoDet = 1) -- SOLO SERVICIOS
begin
	select	ocd.Item, ocd.Cd_Srv as 'Cd_Det', sr.Nombre as 'Nombre', sr.Descrip as 'Descripcion', ocd.PU, t2.Total as 'TotalC', t2.Saldo, 
			isnull(ocd.IB_AtSrv,0) as  'IB_AtSrv', ocd.BIM as 'IMP', ocd.IGV, case(isnull(ocd.IGV,0)) when 0 then 0 else 1 end as 'IncIGV',
			ocd.Total, ocd.Cd_Alm, oc.Cd_CC, oc.Cd_SC, oc.Cd_SS, ocd.Obs, ocd.CA01, ocd.CA02, ocd.CA03, ocd.CA04, ocd.CA05
	from (
		select RucE, Cd_Srv, sum(case when (Cant<0) then 0 else Cant end) as 'Total', sum(Cant) as 'Saldo', Item
		from (
			select RucE, Cd_Srv, Cant, Item from OrdCompraDet
			where RucE = @RucE and Cd_OC = @Cd_OC and Cd_Srv is not null
			union all
			select cp.RucE, Cd_Srv, -Cant, ItemOC from Compra cp
			join CompraDet cpd on cpd.RucE = cp.RucE and cpd.Cd_Com = cp.Cd_Com
			where cp.RucE = @RucE and Cd_OC = @Cd_OC and Cd_Srv is not null and Item is not null
		) as t1
		group by RucE, Cd_Srv, Item
	) as t2
	join OrdCompraDet ocd on ocd.RucE = t2.RucE and ocd.Cd_Srv = t2.Cd_Srv and ocd.Item = t2.Item
	join Servicio2 sr on sr.RucE = t2.RucE and sr.Cd_Srv = t2.Cd_Srv	
	join OrdCompra oc on oc.RucE = @RucE and oc.Cd_OC = @Cd_OC
	where ocd.Cd_OC = @Cd_OC and ocd.Cd_Srv is not null
end
else if(@TipoDet = 2)
begin
	declare @tabla table
	(
		Cd_Prod char (7),
		Cd_Srv char (7),
		Total numeric(13,3),
		Saldo numeric(13,3),
		Item int
	)
	
	insert into @tabla 
	select * from(
		select Cd_Prod, Cd_Srv, sum(case when (Cant<0) then 0 else Cant end) as 'Total', sum(Cant) as 'Saldo', Item
		from (
			select RucE, Cd_Prod, Cd_Srv, Cant, Item from OrdCompraDet
			where RucE = @RucE and Cd_OC = @Cd_OC
			union all
			select cp.RucE, Cd_Prod, Cd_Srv, -Cant, ItemOC from Compra cp
			join CompraDet cpd on cpd.RucE = cp.RucE and cpd.Cd_Com = cp.Cd_Com
			where cp.RucE = @RucE and Cd_OC = @Cd_OC and ItemOC is not null
		) as t1
		group by RucE, Cd_Srv, Cd_Prod, Item
	) as t2

	select ocd.Item ,isnull(ocd.Cd_Prod, ocd.Cd_Srv) as 'Cd_Det', isnull(sr.Nombre, isnull(pr.Nombre1,'')) as 'Nombre',
	isnull(sr.Descrip, isnull(pr.Descrip,''))  as 'Descripcion',isnull(ocd.ID_UMP,0) as ID_UMP,
	isnull(pum.DescripAlt, '------') as 'UnidadMedida', isnull(t1.Total, t2.Total) as 'TotalC',
	isnull(t1.Saldo, t2.Saldo) as 'Saldo', case when (ocd.Cd_Srv is not null) then 1 else 0 end as 'EsServicio', 
	isnull(IB_AtSrv,0) as IB_AtSrv, ocd.PU, ocd.BIM as 'IMP', ocd.IGV, case(isnull(ocd.IGV,0)) when 0 then 0 else 1 end as 'IncIGV',
	ocd.Total, ocd.Cd_Alm, oc.Cd_CC, oc.Cd_SC, oc.Cd_SS, ocd.Obs, ocd.CA01, ocd.CA02, ocd.CA03, ocd.CA04, ocd.CA05

	from OrdCompraDet ocd
	left join @tabla as t1 on ocd.Cd_Prod = t1.Cd_Prod and ocd.Item = t1.Item
	left join @tabla as t2 on ocd.Cd_SRV = t2.Cd_Srv and ocd.Item = t2.Item

	left join Producto2 pr on pr.RucE = @RucE and pr.Cd_Prod = ocd.Cd_Prod
	left join Servicio2 sr on sr.RucE = @RucE and sr.Cd_Srv = ocd.Cd_Srv
	left join Prod_UM pum on pum.RucE = @RucE and pum.Cd_Prod = ocd.Cd_Prod and pum.ID_UMP = ocd.ID_UMP
	join OrdCompra oc on oc.RucE = @RucE and oc.Cd_OC = ocd.Cd_OC
	where ocd.RucE = @RucE and ocd.Cd_OC = @Cd_OC
end

--	LEYENDA
/*	MM : <02/08/11 : Creacion del SP>
	MM : <11/01/12 : Modificacion del SP - Se agrego la validacion por [Item]>
*/
--	PRUEBAS
/*	exec Inv_Consultar_Saldos_OC '11111111111','OC00000247',0,null
	exec Inv_Consultar_Saldos_OC '11111111111','OC00000247',1,null
	exec Inv_Consultar_Saldos_OC '11111111111','OC00000247',2,null
*/
GO
