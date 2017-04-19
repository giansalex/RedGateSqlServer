SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_OrdCompra_Cons]
@RucE nvarchar(11),
--@Ejer nvarchar(4),
@msj varchar(100) output
as

select convert(Nvarchar, co.FecE,103) as FecMov,/*co.RegCtb,*/ /*co.Cd_TD,co.NroSre,*/co.NroOC as NroDoc,
case(co.Cd_Mda) when '01' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when '01' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when '01' then 'S/.' else '$' end as Mda,co.CamMda,co.Cd_OC as CodMov,
convert(Nvarchar,co.FecE,103) as FecED from OrdCompra co
where co.RucE = @RucE and Cd_OC in(select Cd_OC from OrdCompraDet where RucE = @RucE 
and Cd_Prod is not null group by Cd_OC)
--order by convert(Nvarchar,  co.FecMov,102) desc
order by year(co.FecE) desc, month(co.FecE) desc ,day(co.FecE) desc
print @msj
--exec Com_OrdCompra_Cons '11111111111','2010', null
-- Leyenda --
-- CAM : 21/11/10 : <Creacion del procedimiento almacenado>
GO
