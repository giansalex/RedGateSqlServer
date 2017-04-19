SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudReqDetConsxSR3]
@RucE varchar(11),
@Cd_SR char(10),
@msj varchar(100) output
as

if not exists (select * from SolicitudReq where RucE = @RucE and Cd_SR = @Cd_SR)
begin
	set @msj = 'No existe la solicitud de requerimientos con codigo : ' + @Cd_SR
	return
end

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
		select RucE, Cd_Prod, isnull(Cant,0) as Cant, ID_UMP, null as Cd_Srv
		from Inventario where RucE = @RucE and Cd_SR = @Cd_SR		
	) as t1
	group by RucE, Cd_Prod, ID_UMP, Cd_Srv
) as t2

select srd.RucE, srd.Cd_SR, srd.Item as 'Itm', srd.Cd_Prod, srd.Cd_Srv, isnull(sr.Nombre, isnull(pr.Nombre1,'')) as 'Nombre',
isnull(t1.Total, t2.Total) as 'Cant', srd.Descrip ,isnull(srd.ID_UMP,0) as UMP,
isnull(pum.DescripAlt, '------') as 'UnidadMedida', 
isnull(t1.Saldo, t2.Saldo) as 'Saldo', case when (srd.Cd_Srv is not null) then 1 else 0 end as 'EsServicio', 
isnull(IB_AtSrv,0) as IB_AtSrv, srd.Obs, srd.CA01, srd.CA02, srd.CA03, srd.CA04, srd.CA05

from SolicitudReqDet srd
left join @tabla as t1 on srd.Cd_Srv = t1.Cd_Srv
left join @tabla as t2 on srd.Cd_Prod = t2.Cd_Prod

left join Producto2 pr on pr.RucE = @RucE and pr.Cd_Prod = srd.Cd_Prod
left join Servicio2 sr on sr.RucE = @RucE and sr.Cd_Srv = srd.Cd_Srv
left join Prod_UM pum on pum.RucE = @RucE and pum.Cd_Prod = srd.Cd_Prod and pum.ID_UMP = srd.ID_UMP
where srd.RucE = @RucE and srd.Cd_SR = @Cd_SR

--	LEYENDA
/*	MM : <08/08/11 : Creacion del SP>
	
*/
--	PRUEBAS
/*	exec Com_SolicitudReqDetConsxSR3 '11111111111','SR00000169',null
	
*/
GO
