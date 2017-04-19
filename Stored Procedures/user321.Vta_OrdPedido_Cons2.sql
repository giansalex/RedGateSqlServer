SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Vta_OrdPedido_Cons2]
@RucE nvarchar(11),
@EstaAut bit,
@msj varchar(100) output
as
begin
set @EstaAut=0
IF(@EstaAut=1)
BEGIN
select 
convert(Nvarchar, co.FecE,103) as FecMov,
co.NroOP as NroDoc,
case(co.Cd_Mda) when '01' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when '01' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when '01' then 'S/.' else '$' end as Mda,
co.CamMda,
co.Cd_OP as CodMov,
convert(Nvarchar,co.FecE,103) as FecED from OrdPedido co
where co.IB_Aut=1 and co.RucE = @RucE and co.Id_EstOP in ('01','02')
order by year(co.FecE), month(co.FecE) desc ,day(co.FecE) desc
END
ELSE IF(@EstaAut=0)
BEGIN
select 
convert(Nvarchar, co.FecE,103) as FecMov,
co.NroOP as NroDoc,
case(co.Cd_Mda) when '01' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when '01' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when '01' then 'S/.' else '$' end as Mda,
co.CamMda,
co.Cd_OP as CodMov,
convert(Nvarchar,co.FecE,103) as FecED from OrdPedido co
where co.RucE = @RucE and co.Id_EstOP in ('01','02')
order by year(co.FecE), month(co.FecE) desc ,day(co.FecE) desc
END
end
print @msj

-- Leyenda --
-- CAM : 21/11/10 : <Creacion del procedimiento almacenado>
-- exec Vta_OrdPedido_Cons2 '20101949461', null --OSIRIS
-- exec Vta_OrdPedido_Cons2 '11111111111', null --DEMO




GO
