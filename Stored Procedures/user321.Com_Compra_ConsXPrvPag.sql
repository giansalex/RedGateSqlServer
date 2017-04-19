SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_Compra_ConsXPrvPag]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Ejer nvarchar(4),
@TamPag int,
@msj varchar(100) output
as
declare @consulta varchar(8000)
set @consulta = 'select top ' +convert(nvarchar,@TamPag)+' convert(Nvarchar,  co.FecMov,103) as FecMov,co.RegCtb, co.Cd_TD,co.NroSre,co.NroDoc,case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),co.Total*co.CamMda) end  as Soles ,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,co.CamMda,co.Cd_Com as CodMov,  convert(Nvarchar,co.FecED,103) as FecED
from Compra co where co.RucE = '''+@RucE+''' and co.Ejer<= '''+@Ejer+''' and co.Cd_Prv = '''+@Cd_Prv+''' and IB_Anulado = 0
order by  year(co.FecMov) desc, month(co.FecMov) desc, day(co.FecMov) desc, RegCtb desc'
print @consulta
exec (@consulta)
print @msj
--exec Com_Compra_ConsXPrv '11111111111','PRV0001','2010', null

-- Leyenda --
-- FL : 2011-02-16 : <Creacion del procedimiento almacenado>
--Pruebas:
--exec user321.Com_Compra_ConsXPrvPag '11111111111','PRV0004','2010',200,null


GO
