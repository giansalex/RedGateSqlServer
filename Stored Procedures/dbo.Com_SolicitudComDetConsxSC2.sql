SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Com_SolicitudComDetConsxSC2]
@RucE nvarchar(11),
@Cd_SC char(10),
@msj varchar(100) output
as
--VALIDACION

if not exists (select * from SolicitudCom where RucE = @RucE and Cd_SCo = @Cd_SC)
begin
	set @msj = 'No existe la solicitud de compra con el codigo : ' + @Cd_SC	
	return
end

--OBTENCION DEL DETALLE CON LOS SALDOS
declare @tabla table
(
	Cd_Prod char (7),
	Cd_Srv char (7),
	ID_UMP int,
	Total numeric(13,3),
	Saldo numeric(13,3),
	Item int
)
insert into @tabla
select * from (
	select Cd_Prod, Cd_Srv, ID_UMP, sum(case when (Cant<0) then 0 else Cant end) as 'Total', sum(Cant) as 'Saldo', Item
	from(	
		select RucE, Cd_Prod, isnull(Cant,0) as Cant, ID_UMP, Cd_Srv, isnull(IB_AtSrv,0) as IB_AtSrv, Item
		from SolicitudComDet where RucE = @RucE and Cd_SC = @Cd_SC
		union all
		select RucE, Cd_Prod, isnull(-Cant,0) as Cant, ID_UMP, Cd_Srv, isnull(IB_AtSrv,0) as IB_AtSrv, ItemSC
		from OrdCompraDet where RucE = @RucE and Cd_SCo = @Cd_SC
	) as t1
	group by RucE, Cd_Prod, ID_UMP, Cd_Srv, Item
) as t2
order by Item

select scd.RucE, scd.Cd_SC, scd.Cd_SR, scd.Item as 'Itm', scd.Cd_Prod, scd.Cd_SRV, ISNULL(pr.Nombre1, ISNULL(sr.Nombre,'')) as 'Nombre',
ISNULL(t1.Total, t2.Total) as 'Cant', scd.Descrip, ISNULL(scd.ID_UMP, 0) as UMP,
isnull(pum.DescripAlt, '------') as 'UnidadMedida',
isnull(t1.Saldo, t2.Saldo) as 'Saldo', case when (scd.Cd_SRV is not null) then 1 else 0 end as 'EsServicio', 
isnull(IB_AtSrv,0) as IB_AtSrv, scd.Obs, scd.CA01, scd.CA02, scd.CA03, scd.CA04, scd.CA05
from SolicitudComDet scd
left join @tabla as t1 on scd.Cd_Prod = t1.Cd_Prod and t1.Item = scd.Item
left join @tabla as t2 on scd.Cd_SRV = t2.Cd_Srv and t2.Item = scd.Item

left join Producto2 pr on pr.RucE = @RucE and pr.Cd_Prod = scd.Cd_Prod
left join Servicio2 sr on sr.RucE = @RucE and sr.Cd_Srv = scd.Cd_SRV
left join Prod_UM pum on pum.RucE = @RucE and pum.Cd_Prod = scd.Cd_Prod and pum.ID_UMP = scd.ID_UMP
where scd.RucE = @RucE and scd.Cd_SC = @Cd_SC

--	LEYENDA
/*	MM : <11/08/11 : Creacion del SP>
	
*/
--	PRUEBAS
/*	exec Com_SolicitudComDetConsxSC2 '11111111111','SC00000169',null
	
*/
GO
