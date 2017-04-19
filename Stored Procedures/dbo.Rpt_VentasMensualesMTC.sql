SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VentasMensualesMTC]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecIni datetime,
@FecFin datetime
as
--set @RucE = '11111111111'
--set @Ejer = '2012'
--set @FecIni = '01/09/2012'
--set @FecFin = '30/09/2012'

Select *,upper(DATENAME(month, @FecIni)) as MesCons,year(@FecIni) as AnioCons from Empresa Where Ruc = @RucE 


select
	ROW_NUMBER() OVER(PARTITION BY sm.Cd_Prod ORDER BY sm.Cd_Prod ASC) AS 'Item',
sm.Cd_Prod,p.Nombre1 as Nombre,p.Descrip,p.CodCo1_ as CodCom,Serial,p.CA01 as Cd_Homo,i.Cd_Clt,Case when isnull(c.RSocial,'')<>'' then c.RSocial else c.ApPat +' '+c.ApMat+' '+c.Nom end as Cliente,c.NDoc as RucCli,c.Direc as DirecCli
from Inventario i
left join Venta v on v.RucE = i.RucE and v.Eje = i.Ejer and v.Cd_Vta = i.Cd_vta
left join SerialMov sm on sm.RucE = i.RucE and sm.Cd_Inv = i.Cd_Inv
left join Producto2 p on p.RucE = i.RucE and p.Cd_Prod = sm.Cd_Prod 
left join Cliente2 as c on c.RucE = i.RucE and c.Cd_Clt = i.Cd_Clt
where i.RucE = @RucE and i.Ejer = @Ejer and v.FecMov between @FecIni and @FecFin +' 23:59:29'-- and i.Cd_TDES = 'VT'
Order by sm.Cd_Prod
--<Creado>: Ja <03/09/2012>
--Exec Rpt_VentasMensualesMTC '11111111111','2012','01/09/2012','30/09/2012'

GO
