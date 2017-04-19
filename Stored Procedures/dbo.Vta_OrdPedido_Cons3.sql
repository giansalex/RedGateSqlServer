SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_OrdPedido_Cons3]
@RucE nvarchar(11),
@EstaAut bit,
@msj varchar(100) output
as
begin
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
--where co.RucE = @RucE and co.Id_EstOP in ('01','02') and co.IB_Aut=1  
where co.RucE = @RucE and co.Id_EstOP in ('01','02') and (co.IB_Aut=1 or TipAut=0 ) --PV 2017-04-05: Modificamos para que tb traiga las OP que no requieran autorizacion
order by year(co.FecE) desc, month(co.FecE) desc ,day(co.FecE) desc
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
order by year(co.FecE) desc, month(co.FecE) desc ,day(co.FecE) desc
END
end
print @msj

-- Leyenda --
-- CAM : 21/11/10 : <Creacion del procedimiento almacenado>
-- FL  : 18/04/11 : <modificacion del sp para que cargue correctamente>
-- PV : 2017-04-05: Modificamos para que tb traiga las OP que no requieran autorizacion (TipAut=0)

--Pruebas:
-- exec Vta_OrdPedido_Cons2 '20101949461', null --OSIRIS
-- exec Vta_OrdPedido_Cons3 '11111111111',1,null --DEMO
-- exec Vta_OrdPedido_Cons3 '20160000001',1,null -- Muestra
-- select * from OrdPedido where ruce='20160000001'
GO
