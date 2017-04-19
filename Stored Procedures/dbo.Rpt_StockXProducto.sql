SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_StockXProducto]
--declare 
@RucE nvarchar(11),
--@Cd_Prod nvarchar(11), 
--@Ejer nvarchar(4), 
--@Cd_CC nvarchar(10), 
--@Cd_SC nvarchar(10), 
--@Cd_SS nvarchar(10), 
@FecHasta datetime,
@MostrarStock bit
as
--set @MostrarStock = 0
--set @RucE = '20514402346'
----set @Cd_Prod = 'PD00001'--PD00001
----set @Ejer = '2012'
----set @Cd_CC = ''
----set @Cd_SC = ''
----set @Cd_SS = ''
--set @FecHasta = '31/03/2012 23:59:29'
select * from 
(
select
p.Cd_Prod, p.CodCo1_ as CodCom,inv.ID_UMP,um.NCorto,um.Nombre,/*inv.Cd_CC,inv.Cd_SC,inv.Cd_SS,*/ sum(inv.Cant_Ing) as Stock,
p.Nombre1 as NombreProd,/*p.Descrip,*/
isnull(cl.Nombre,'') as Clase,
isnull(cls.Nombre,'') as [Sub Clase],
isnull(clss.Nombre,'') as [Sub Sub Clase],
case when sum(inv.Cant_Ing) = 0 then 0 else 1 end as IB_Stock
,pum.Factor
from 
Inventario inv 
left join Producto2 p on p.RucE = inv.RucE and p.Cd_Prod = inv.Cd_Prod
LEFT join Prod_UM pum on pum.RucE = inv.RucE and pum.ID_UMP = inv.ID_UMP and pum.Cd_Prod = p.Cd_Prod
LEFT join UnidadMedida um on um.Cd_UM = pum.Cd_UM
left join Clase cl on cl.Cd_CL = p.Cd_CL and cl.RucE = p.RucE
left join ClaseSub cls on cls.Cd_CL = p.Cd_CLS and cls.Cd_CL = cl.Cd_CL and cls.RucE = p.RucE
left join ClaseSubSub clss on clss.Cd_CLSS = p.Cd_CLSS and clss.Cd_CLS = cls.Cd_CLS and clss.RucE = p.RucE
where inv.RucE = @RucE /*and Ejer = @Ejer*/ 
--and case when isnull(@Cd_CC,'') <> '' then inv.Cd_CC else  '' end = isnull(@Cd_CC,'') 
--and case when isnull(@Cd_SC,'') <> '' then inv.Cd_SC else  '' end = isnull(@Cd_SC,'') 
--and case when isnull(@Cd_SS,'') <> '' then inv.Cd_SS else  '' end = isnull(@Cd_SS,'')  
--and case when isnull(@Cd_Prod,'')<>'' then inv.Cd_Prod else '' end = isnull(@Cd_Prod,'')
and inv.FecMov <= @FecHasta
group by 
inv.Cd_Prod,inv.ID_UMP,um.NCorto,pum.Factor,um.Nombre,inv.ID_UMBse,--inv.Cd_CC,inv.Cd_SC,inv.Cd_SS,
p.Cd_Prod,p.CodCo1_,p.Nombre1,p.Descrip,p.Cd_CL,cl.Nombre,cl.NCorto,p.Cd_CLS,cls.Nombre,cls.NCorto,p.Cd_CLSS,clss.Nombre,clss.NCorto
--order by inv.Cd_Prod,inv.ID_UMP

union all

select 
p.Cd_Prod, p.CodCo1_ as CodCom,pum.ID_UMP,um.NCorto,um.Nombre,
0 as Stock,
p.Nombre1 as NombreProd,
isnull(cl.Nombre,'') as Clase,
isnull(cls.Nombre,'') as [Sub Clase],
isnull(clss.Nombre,'') as [Sub Sub Clase],
0 as IB_Stock,
pum.Factor
from Producto2 p 
LEFT join Prod_UM pum on pum.RucE = p.RucE and pum.Cd_Prod = p.Cd_Prod
LEFT join UnidadMedida um on um.Cd_UM = pum.Cd_UM
left join Clase cl on cl.Cd_CL = p.Cd_CL and cl.RucE = p.RucE
left join ClaseSub cls on cls.Cd_CL = p.Cd_CLS and cls.Cd_CL = cl.Cd_CL and cls.RucE = p.RucE
left join ClaseSubSub clss on clss.Cd_CLSS = p.Cd_CLSS and clss.Cd_CLS = cls.Cd_CLS and clss.RucE = p.RucE
where p.RucE = @RucE and p.Cd_Prod not in ( select distinct Cd_Prod from Inventario where RucE = @RucE)
) as t
where case when isnull(@MostrarStock,'') <>'' then t.IB_Stock else '' end = isnull(@MostrarStock,'')


select RSocial,Ruc,Direccion from Empresa where Ruc = @RucE 


--<Create>
--<JA: 16/03/2012>
--exec Rpt_StockXProducto '20514402346','31/03/2012',0
GO
