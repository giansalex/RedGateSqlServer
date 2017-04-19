SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompra_ConsXPrvOrd]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Colum nvarchar(15),
@EstaAut bit,
@msj varchar(100) output
as
BEGIN
declare @consulta varchar(8000)
IF(@EstaAut=1)
BEGIN
set @consulta=
'select convert(Nvarchar,  co.FecE,103) as FecMov,
co.Cd_OC as CodMov, co.NroOC as NroDoc,
case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),
co.Total*co.CamMda) end  as Soles,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), 
co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,
co.CamMda,
--(select Cd_Com from Compra as v where v.RucE = @RucE and v.Cd_OC = co.Cd_OC) as CodCom,  
null as CodCom,
convert(Nvarchar,co.FecE,103) as FecED 
from OrdCompra co
where co.IB_Aut=1 and co.RucE = '''+@RucE+''' and co.Cd_Prv = '''+@Cd_Prv+''' and co.Id_EstOC in (''01'',''02'')
order by  '+@Colum+' desc'
print @consulta
exec (@consulta)
END
ELSE IF(@EstaAut=0)
BEGIN
set @consulta=
'select convert(Nvarchar,  co.FecE,103) as FecMov,
co.Cd_OC as CodMov, co.NroOC as NroDoc,
case(co.Cd_Mda) when ''01'' then co.Total else convert(numeric(13,2),
co.Total*co.CamMda) end  as Soles,
case(co.Cd_Mda) when ''01'' then convert(numeric(13,2), 
co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when ''01'' then ''S/.'' else ''$'' end as Mda,
co.CamMda,
--(select Cd_Com from Compra as v where v.RucE = @RucE and v.Cd_OC = co.Cd_OC) as CodCom,  
null as CodCom,
convert(Nvarchar,co.FecE,103) as FecED 
from OrdCompra co
where co.RucE = '''+@RucE+''' and co.Cd_Prv = '''+@Cd_Prv+''' and co.Id_EstOC in (''01'',''02'')
order by  '+@Colum+' desc'
print @consulta
exec (@consulta)
END

END
print @msj
-- Leyenda --
-- FL : 19/04/11 : <creacion del procedimiento almacenado>
-- OBSERVACIONES:
-- POR EL MOMENTO, SE ESTA DEVOLVIENDO NULL EN EL CODIGO DE COMPRA YA QUE NO SE PUEDE MOSTRAR 2 RESULTADOS EN LA
-- SUBCONSULTA (PUEDE SER QUE EXISTA 2 O MAS COMPRAS PARA UNA OC)
--Pruebas:
--exec Com_OrdCompra_ConsXPrvOrd '11111111111','PRV0004','FecE',0,''










GO
