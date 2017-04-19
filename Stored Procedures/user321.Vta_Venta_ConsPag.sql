SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Vta_Venta_ConsPag]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@TamPag int,
@msj varchar(100) output
as
declare @consulta varchar(8000)
set @consulta =
'select top '+convert(nvarchar,@TamPag)+' convert(Nvarchar,  ve.FecMov,103) as FecMov,ve.RegCtb, ve.Cd_TD,ve.NroSre,ve.NroDoc,case(ve.Cd_Mda) when ''01'' then ve.Total else convert(numeric(13,2),ve.Total*ve.CamMda) end  as Soles ,
case(ve.Cd_Mda) when ''01'' then convert(numeric(13,2), case(ve.CamMda) when 0 then 0  else (ve.Total/ve.CamMda) end) else ve.Total end as Dolares ,
case(ve.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,ve.CamMda,ve.Cd_Vta as CodMov, convert(Nvarchar,ve.FecED,103) as FecED from Venta ve
where ve.RucE = '''+@RucE+''' and ve.Eje <= '''+@Ejer+''' and IB_Anulado = 0
--order by convert(Nvarchar,  ve.FecMov,102) desc 
order by year(ve.FecMov) desc, month(ve.FecMov) desc, day(ve.FecMov) desc,RegCtb desc '
print @consulta
exec (@consulta)
print @msj
--exec Vta_Venta_ConsPag '11111111111','2011',200, null
-- Leyenda --
-- FL  : 2011-02-21 : <Creacion del procedimiento almacenado>




GO
