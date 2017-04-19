SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_Compra_ConsPag]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@TamPag int,
@msj varchar(100) output
as
declare @consulta varchar(8000)
set @consulta =
'select top '+convert(nvarchar,@TamPag)+' convert(Nvarchar, co.FecMov,103) as FecMov,co.RegCtb, co.Cd_TD,co.NroSre,co.NroDoc,
case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,co.CamMda,co.Cd_Com as CodMov,
convert(Nvarchar,co.FecED,103) as FecED from Compra co
where co.RucE = '''+@RucE+''' and co.Ejer<= '''+@Ejer+''' and IB_Anulado = 0 and Cd_Com in(select Cd_Com from CompraDet where RucE = '''+@RucE+''' and Cd_Prod is not null group by Cd_Com)
--order by convert(Nvarchar,  co.FecMov,102) desc
order by year(co.FecMov) desc, month(co.FecMov) desc ,day(co.FecMov) desc, RegCtb asc'
print @Consulta
exec (@consulta)
print @msj
--exec Com_Compra_ConsPag '11111111111','2011','200',null
-- Leyenda --
-- FL : 2011-02-21 : <Creacion del procedimiento almacenado>


GO
