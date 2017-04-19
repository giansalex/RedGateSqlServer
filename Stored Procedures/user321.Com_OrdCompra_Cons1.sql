SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_OrdCompra_Cons1]
@RucE nvarchar(11),
@EstaAut bit,
@msj varchar(100) output
as
BEGIN
set @EstaAut=0
IF(@EstaAut=1)
BEGIN
select convert(Nvarchar, co.FecE,103) as FecMov,co.NroOC as NroDoc,
case(co.Cd_Mda) when '01' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when '01' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when '01' then 'S/.' else '$' end as Mda,co.CamMda,co.Cd_OC as CodMov,
convert(Nvarchar,co.FecE,103) as FecED from OrdCompra co
where co.IB_Aut=1 and co.RucE = @RucE and Cd_OC in(select Cd_OC from OrdCompraDet where RucE = @RucE 
and Cd_Prod is not null group by Cd_OC) and co.Id_EstOC in ('01','02')
--order by convert(Nvarchar,  co.FecMov,102) desc
order by year(co.FecE) desc, month(co.FecE) desc ,day(co.FecE) desc, SUBSTRING ( CONVERT(char(38),  co.FecE,121), 12,8) desc
END
ELSE IF(@EstaAut=0)
BEGIN
select convert(Nvarchar, co.FecE,103) as FecMov,co.NroOC as NroDoc,
case(co.Cd_Mda) when '01' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when '01' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when '01' then 'S/.' else '$' end as Mda,co.CamMda,co.Cd_OC as CodMov,
convert(Nvarchar,co.FecE,103) as FecED from OrdCompra co
where co.RucE = @RucE and Cd_OC in(select Cd_OC from OrdCompraDet where RucE = @RucE 
and Cd_Prod is not null group by Cd_OC) and co.Id_EstOC in ('01','02')
--order by convert(Nvarchar,  co.FecMov,102) desc
order by year(co.FecE) desc, month(co.FecE) desc ,day(co.FecE) desc, SUBSTRING ( CONVERT(char(38),  co.FecE,121), 12,8) desc
END

END
print @msj
--exec Com_OrdCompra_Cons1 '11111111111',1,null
-- Leyenda --
-- Nueva version que ordena por Fecha, Hora en ese orden
-- CAM : 03/01/11 : <Creacion del procedimiento almacenado>
-- FL  : 04/03/11 : <modificacion del sp>




GO
