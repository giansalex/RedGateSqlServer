SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_ReporteRutasFET]
@RucE nvarchar(11),@Ejer nvarchar(4),@Ruta nvarchar(100),@FecIni datetime,@FecFin datetime
as
--declare 
--set @RucE = '20100286981'
--set @Ejer = '2012'
--set @Ruta = ''


select v.RucE,vd.Cd_Prod,clt.CA01 as Ruta,p.CodCo1_ as CodCom,p.Nombre1 as NomProd,p.Descrip as DescripProd,sum(vd.Cant) as Cantidad
from venta v 
left join VentaDet vd on vd.RucE = v.RucE and vd.Cd_Vta = v.Cd_Vta
left join Producto2 p on p.RucE = v.RucE and p.Cd_Prod = vd.Cd_Prod
left join Cliente2 clt on clt.RucE = v.RucE and clt.Cd_clt = v.Cd_Clt
where v.RucE = @RucE and v.eje = @Ejer and case when isnull(@Ruta,'') != '' then clt.CA01 else '' end  = isnull(@Ruta,'') and v.FecMov between @FecIni and @FecFin+' 23:59:29'
group by v.RucE,vd.Cd_Prod,p.CodCo1_,p.Nombre1 ,p.Descrip, clt.CA01
order by clt.CA01                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            



select v.RucE,clt.CA01 as Ruta,case when isnull(clt.RSocial,'')='' then clt.ApPat +' '+ clt.ApMat +' '+clt.Nom else clt.RSocial end as Cliente
,vd.Cd_Prod,p.Nombre1 as NomProd,sum(vd.Cant) as Cantidad
from venta v 
left join VentaDet vd on vd.RucE = v.RucE and vd.Cd_Vta = v.Cd_Vta
left join Producto2 p on p.RucE = v.RucE and p.Cd_Prod = vd.Cd_Prod
left join Cliente2 clt on clt.RucE = v.RucE and clt.Cd_clt = v.Cd_Clt
where v.RucE = @RucE and v.eje = @Ejer and case when isnull(@Ruta,'') != '' then clt.CA01 else '' end  = isnull(@Ruta,'')and v.FecMov between @FecIni and @FecFin+' 23:59:29'
group by v.RucE,clt.CA01,case when isnull(clt.RSocial,'')='' then clt.ApPat +' '+ clt.ApMat +' '+clt.Nom else clt.RSocial end,vd.Cd_Prod,p.CodCo1_,p.Nombre1 ,p.Descrip 
order by clt.CA01

--<Creado: JA> <25/05/2012>
--exec Rpt_ReporteRutasFET '20100286981','2012','Ruta 1'
GO
