SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_OrdPedido_ConsXCltPag1]
@RucE nvarchar(11),
@Cd_Clt char(10),
@TamPag int,
@EstaAut bit,
@msj varchar(100) output
as
begin
declare @consulta varchar(8000)
IF(@EstaAut=1)
BEGIN
set @consulta =
'select top '+convert(nvarchar,@TamPag)+'  convert(Nvarchar,  co.FecE,103) as FecMov,
co.Cd_OP as CodMov, co.NroOP as NroDoc,
case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),
co.Total*co.CamMda) end  as Soles,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), 
co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,
co.CamMda,
--(select Cd_Vta from Venta as v where v.RucE = @RucE and v.Cd_OP = co.Cd_OP) as CodVta,  
null as CodVta,
convert(Nvarchar,co.FecE,103) as FecED 
from OrdPedido co
where co.IB_Aut=1 and co.RucE = '''+@RucE+''' and co.Cd_Clt = '''+@Cd_Clt+''' and co.Id_EstOP in (''01'',''02'')
order by  year(co.FecE) desc, month(co.FecE) desc, day(co.FecE) desc'
print @consulta
exec (@consulta)
END
ELSE IF(@EstaAut=0)
BEGIN
set @consulta =
'select top '+convert(nvarchar,@TamPag)+'  convert(Nvarchar,  co.FecE,103) as FecMov,
co.Cd_OP as CodMov, co.NroOP as NroDoc,
case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),
co.Total*co.CamMda) end  as Soles,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), 
co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,
co.CamMda,
--(select Cd_Vta from Venta as v where v.RucE = @RucE and v.Cd_OP = co.Cd_OP) as CodVta,  
null as CodVta,
convert(Nvarchar,co.FecE,103) as FecED 
from OrdPedido co
where co.RucE = '''+@RucE+''' and co.Cd_Clt = '''+@Cd_Clt+''' and co.Id_EstOP in (''01'',''02'')
order by  year(co.FecE) desc, month(co.FecE) desc, day(co.FecE) desc'
print @consulta
exec (@consulta)
END
end
print @msj
-- Leyenda --
-- FL : 22/02/11 : <Creacion del procedimiento almacenado>
-- OBSERVACION:
-- NO SE MUESTRA EL CODIGO DE VENTA PORQUE PUEDE SER QUE UNA ORDEN DE PEDIDO TENGA 2 O MAS VENTAS RELACIONADAS
--Pruebas:
--exec Vta_OrdPedido_ConsXClt '11111111111','CLT0000009',''











GO
