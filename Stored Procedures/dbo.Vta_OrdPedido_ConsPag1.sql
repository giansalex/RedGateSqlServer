SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_OrdPedido_ConsPag1]
@RucE nvarchar(11),
@TamPag int,
@EstaAut bit,
@msj varchar(100) output
as
begin
declare @consulta varchar(8000)
IF(@EstaAut=1)
BEGIN
set @consulta=
'select top '+convert(nvarchar,@TamPag)+' convert(Nvarchar, co.FecE,103) as FecMov,/*co.RegCtb,*/ /*co.Cd_TD,co.NroSre,*/co.NroOP as NroDoc,
case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,co.CamMda,co.Cd_OP as CodMov,
convert(Nvarchar,co.FecE,103) as FecED from OrdPedido co
where co.IB_Aut=1 and co.RucE = '''+@RucE+''' and Cd_OP in(select Cd_OP from OrdPedidoDet where RucE = '''+@RucE+''' 
and Cd_Prod is not null group by Cd_OP) and co.Id_EstOP in (''01'',''02'')
--order by convert(Nvarchar,  co.FecMov,102) desc
order by year(co.FecE), month(co.FecE) desc ,day(co.FecE) desc'
print @consulta
exec (@consulta)
END
ELSE IF(@EstaAut=0)
BEGIN
set @consulta=
'select top '+convert(nvarchar,@TamPag)+' convert(Nvarchar, co.FecE,103) as FecMov,/*co.RegCtb,*/ /*co.Cd_TD,co.NroSre,*/co.NroOP as NroDoc,
case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,co.CamMda,co.Cd_OP as CodMov,
convert(Nvarchar,co.FecE,103) as FecED from OrdPedido co
where co.RucE = '''+@RucE+''' and Cd_OP in(select Cd_OP from OrdPedidoDet where RucE = '''+@RucE+''' 
and Cd_Prod is not null group by Cd_OP) and co.Id_EstOP in (''01'',''02'')
--order by convert(Nvarchar,  co.FecMov,102) desc
order by year(co.FecE), month(co.FecE) desc ,day(co.FecE) desc'
print @consulta
exec (@consulta)
END
end
print @msj
--exec Com_OrdCompra_Cons '11111111111','2010', null
-- Leyenda --
-- FL : 22/02/11 : <Creacion del procedimiento almacenado>









GO
