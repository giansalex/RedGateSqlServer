SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VentasMensualesMTC2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Prdo nvarchar(2)
as
--set @RucE = '11111111111'
--set @Ejer = '2012'
--set @FecIni = '01/09/2012'
--set @FecFin = '30/09/2012'

Select *,''as MesCons, '' as AnioCons from Empresa Where Ruc = @RucE 

select
case when isnull(Serial,'')<>'' then 0 else abs(i.cant) end as Cant,
i.Cd_Prod,
p.Nombre1 as Nombre,
m.Nombre as Descrip,
p.CodCo1_ as CodCom,
isnull(Serial,'-') as Serial,
isnull(p.CA01,'-') as Cd_Homo,
i.Cd_Clt,
Case when isnull(c.RSocial,'')<>'' then c.RSocial else c.ApPat +' '+c.ApMat+' '+c.Nom end as Cliente,
c.NDoc as RucCli,
c.Direc as DirecCli
from Inventario i 
left join GuiaRemision gr on gr.RucE = i.RucE and gr.Cd_GR = i.Cd_GR
left join Venta v on v.RucE = i.RucE and v.Eje = i.Ejer and convert(int,v.CA02) = CONVERT(int,gr.NroGR)
left join SerialMov sm on sm.RucE = i.RucE and sm.Cd_Inv = i.Cd_Inv
left join Producto2 p on p.RucE = i.RucE and p.Cd_Prod = i.Cd_Prod 
left join Cliente2 as c on c.RucE = i.RucE and c.Cd_Clt = i.Cd_Clt
left join Marca m on m.RucE = i.RucE and m.Cd_Mca = p.Cd_Mca
where i.RucE = @RucE and i.Ejer = @Ejer and i.IC_ES ='S' and v.Prdo = @Prdo and isnull(p.CA01,'')<>''
Order by sm.Cd_Prod,i.Cd_Clt
--<Creado>: Ja <03/09/2012>
--Exec Rpt_VentasMensualesMTC2 '11111111111','2012','02'

GO
