SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompra_ConsXPrv1]
@RucE nvarchar(11),
@Cd_Prv char(7),
@EstaAut bit,
@msj varchar(100) output
as
BEGIN
IF(@EstaAut=1)
BEGIN
select  convert(Nvarchar,  co.FecE,103) as FecMov,
co.Cd_OC as CodMov, co.NroOC as NroDoc,
case(co.Cd_Mda) when '01' then co.Total else convert(numeric(13,2),
co.Total*co.CamMda) end  as Soles,
case(co.Cd_Mda) when '01' then convert(numeric(13,2), 
co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when '01' then 'S/.' else '$' end as Mda,
co.CamMda,
--(select Cd_Com from Compra as v where v.RucE = @RucE and v.Cd_OC = co.Cd_OC) as CodCom,  
null as CodCom,
convert(Nvarchar,co.FecE,103) as FecED 
from OrdCompra co
where co.RucE = @RucE and co.Cd_Prv = @Cd_Prv and co.Id_EstOC in ('01','02') and (co.ib_aut = 1 or co.tipAut = 0)
order by  year(co.FecE) desc, month(co.FecE) desc, day(co.FecE) desc
END

ELSE IF(@EstaAut=0)
BEGIN
select  convert(Nvarchar,  co.FecE,103) as FecMov,
co.Cd_OC as CodMov, co.NroOC as NroDoc,
case(co.Cd_Mda) when '01' then co.Total else convert(numeric(13,2),
co.Total*co.CamMda) end  as Soles,
case(co.Cd_Mda) when '01' then convert(numeric(13,2), 
co.Total/co.CamMda) else co.Total end as Dolares ,
case(co.Cd_Mda) when '01' then 'S/.' else '$' end as Mda,
co.CamMda,
--(select Cd_Com from Compra as v where v.RucE = @RucE and v.Cd_OC = co.Cd_OC) as CodCom,  
null as CodCom,
convert(Nvarchar,co.FecE,103) as FecED 
from OrdCompra co
where co.RucE = @RucE and co.Cd_Prv = @Cd_Prv and co.Id_EstOC in ('01','02')
order by  year(co.FecE) desc, month(co.FecE) desc, day(co.FecE) desc
END

END
print @msj
-- Leyenda --
-- CAM : 18/11/10 : <Creacion del procedimiento almacenado>
-- CAM : 19/11/10 : <Modificacion del SP>
-- FL  : 04/03/11 : <modificacion del sp>
-- OBSERVACIONES:
-- POR EL MOMENTO, SE ESTA DEVOLVIENDO NULL EN EL CODIGO DE COMPRA YA QUE NO SE PUEDE MOSTRAR 2 RESULTADOS EN LA
-- SUBCONSULTA (PUEDE SER QUE EXISTA 2 O MAS COMPRAS PARA UNA OC)
--Pruebas:
--exec Com_OrdCompra_ConsXPrv '11111111111','prv0004',1,''






GO
