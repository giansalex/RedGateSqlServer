SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompraDet_Cons]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as
if not exists (select * from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC)
begin
	set @msj = 'No existe la orden de compra con el codigo ' + @Cd_OC
	return
end
declare @tabla table
(
	Item int,
	Cd_Prod char (7),
	Cd_Srv char (7),
	ID_UMP int,
	Total numeric(13,3),
	Saldo numeric(13,3)
)
insert into @tabla
select * from (
	select Item, Cd_Prod, Cd_Srv, ID_UMP, sum(case when(Cant<0) then 0 else Cant end) as 'Total',  sum(Cant) as 'Saldo'
	from(
	select Item, Cd_Prod, ID_UMP, Cant, Cd_Srv from ordCompraDet where RucE = @RucE and Cd_OC = @Cd_OC
	union all
	select Item, Cd_Prod, ID_UMP, -Cant, null Cd_Srv from Inventario where RucE = @RucE and Cd_OC = @Cd_OC
	union all
	select ItemOC, Cd_Prod, ID_UMP, -Cant, Cd_Srv from CompraDet where RucE = @RucE 
	and Cd_Com in (select Cd_Com from Compra where RucE = @RucE and Cd_OC = @Cd_OC)
	and ItemOC is not null
	) as t1
	group by item, Cd_Prod, ID_UMP, Cd_Srv
) as t2

select	ocd.RucE, ocd.Item, ocd.Cd_OC, ocd.Cd_Prod, ocd.Cd_Srv, ocd.Descrip, ocd.PU, ocd.ID_UMP, um.DescripAlt as UM, 
		ocd.Cant, t1.Saldo, ocd.PendRcb, ocd.Valor, ocd.DsctoP, ocd.DsctoI, ocd.BIM, ocd.IGV, 
		case(isnull(ocd.IGV,0))when 0 then 0 else 1 end as IncIGV, ocd.Total,ocd.Cd_Alm, ocd.Obs,
		ocd.CA01,ocd.CA02,ocd.CA03,ocd.CA04,ocd.CA05, ocd.ItemSC,
		case when (ocd.Cd_SRV is not null) then 1 else 0 end as 'EsServicio'
		
from OrdCompraDet ocd
join @tabla t1 on t1.Item = ocd.Item
left join Prod_UM um on ocd.RucE = um.RucE and ocd.Cd_Prod = um.Cd_Prod and ocd.ID_UMP = um.ID_UMP
where ocd.RucE = @RucE and ocd.Cd_OC = @Cd_OC

/*
select	oc.Item, oc.Cd_OC,oc.Cd_Prod,oc.Cd_Srv, oc.Descrip, oc.PU,oc.ID_UMP ,um.DescripAlt as UM,
		oc.Cant, oc.PendRcb, oc.Valor, oc.DsctoP, oc.DsctoI, oc.BIM,oc.IGV,
		case(isnull(oc.IGV,0))when 0 then 0 else 1 end as IncIGV,oc.Total, oc.Cd_Alm, oc.Obs, 
		oc.CA01,oc.CA02,oc.CA03,oc.CA04,oc.CA05
from OrdCompraDet oc
Left join Prod_UM um on oc.RucE = um.RucE and oc.Cd_Prod = um.Cd_Prod and oc.ID_UMP= um.ID_UMP
where oc.RucE=@RucE and oc.Cd_OC=@Cd_OC and oc.Item = @Item
*/

--	LEYENDA
/*	MM : <11/08/11 : Creacion del SP>
	
*/
--	PRUEBAS
/*	exec Com_OrdCompraDet_Cons '11111111111','OC00000178',null
	
*/
GO
