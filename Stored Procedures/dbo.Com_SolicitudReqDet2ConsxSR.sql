SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Com_SolicitudReqDet2ConsxSR]
@RucE varchar(11),
@Cd_SR char(10),
@msj varchar(100) output
as

if not exists (select * from SolicitudReq2 where RucE = @RucE and Cd_SR = @Cd_SR)
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
		from SolicitudReqDet2 where RucE = @RucE and Cd_SR = @Cd_SR
		union all
		select RucE, Cd_Prod, isnull(Cant,0) as Cant, ID_UMP, null as Cd_Srv
		from Inventario where RucE = @RucE and Cd_SR = @Cd_SR		
	) as t1
	group by RucE, Cd_Prod, ID_UMP, Cd_Srv
) as t2

select srd.RucE,
	   srd.Cd_SR,
	   srd.Item,
	   srd.Cd_Prod,
	   isnull(srd.ID_UMP,0) as 'ID_UMP',
	   srd.Cd_Srv,
	   srd.Descrip,
	   isnull(t1.Total, t2.Total) as 'Cant',
	   srd.Obs,
	   srd.FecCrea,
	   srd.FecMdf,
	   srd.Cd_CC,
	   srd.Cd_SC,
	   srd.Cd_SS,
	   srd.IC_EstadoPS,
	   srd.IC_EstadoInv,
	   srd.CA01,
	   srd.CA02,
	   srd.CA03,
	   srd.CA04,
	   srd.CA05,
	   srd.CA06,
	   srd.CA07,
	   srd.CA08,
	   srd.CA09,
	   srd.CA10,
	   isnull(pum.DescripAlt, '------') as 'DescripUMP'
	   

from SolicitudReqDet2 srd
left join @tabla as t1 on srd.Cd_Srv = t1.Cd_Srv
left join @tabla as t2 on srd.Cd_Prod = t2.Cd_Prod

left join Producto2 pr on pr.RucE = @RucE and pr.Cd_Prod = srd.Cd_Prod
left join Servicio2 sr on sr.RucE = @RucE and sr.Cd_Srv = srd.Cd_Srv
left join Prod_UM pum on pum.RucE = @RucE and pum.Cd_Prod = srd.Cd_Prod and pum.ID_UMP = srd.ID_UMP
where srd.RucE = @RucE and srd.Cd_SR = @Cd_SR
GO
