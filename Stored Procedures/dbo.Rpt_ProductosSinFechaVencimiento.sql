SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_ProductosSinFechaVencimiento]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecHasta datetime,
@CantMes int
as
--set @RucE = '20102028687'
--set @Ejer = '2012'
--set @CantMes = 2
--exec Rpt_ProductosSinFechaVencimiento '20102028687','2012','31/12/2012',2

select e.*,@FecHasta as FechaHasta,@CantMes as NumMeses from Empresa e Where e.Ruc = @RucE

select
datediff(month,i.FecMov,@FecHasta) as CantMesAlmacen 
,p.CodCo1_ as CodCoProd
,p.Cd_Prod
,p.Nombre1 as NomProd
,um.Nombre as NomUM
,um.NCorto as NCortoUM
,sum(case when isnull(isnull(pl.Cant,0)*isnull(pu.Factor,0),0)=0 then i.Cant else pl.Cant*pu.Factor end ) as Stock
,i.FecMov
,l.Cd_Lote
,l.NroLote
,l.FecCaducidad
,l.FecFabricacion
,case when datediff(month,@FecHasta,l.FecCaducidad) < 0 then convert(varchar,datediff(month,@FecHasta,l.FecCaducidad)) else '' end as MesVencido
,case when datediff(month,@FecHasta,l.FecCaducidad) >= 0 then convert(varchar,datediff(month,@FecHasta,l.FecCaducidad)) else '' end as MesXVencer
from 
Inventario i
left join Producto2 p on p.RucE = i.RucE and p.Cd_Prod = i.Cd_Prod
left join ProductoXLote pl on pl.RucE = i.RucE and pl.Ejer = i.Ejer and pl.RegCtbInv = i.RegCtb and pl.Cd_Prod = p.Cd_Prod
left join Lote l on l.RucE = i.RucE and l.Cd_Lote =pl.Cd_Lote 
left join Prod_UM pu on pu.RucE = i.RucE and pu.Cd_Prod = p.Cd_Prod and pu.ID_UMP = i.ID_UMP 
left join UnidadMedida um on um.Cd_UM = pu.Cd_UM
where 
i.RucE = @RucE 
and case when isnull(@Ejer,'') <> '' then i.Ejer else '' end = isnull(@Ejer,'') 
and i.FecMov <@FecHasta
and i.IC_ES = 'E'
and isnull(l.FecCaducidad,'')=''
and datediff(month,i.FecMov,@FecHasta) >= @CantMes

group by 
p.CodCo1_
,i.FecMov
,p.Cd_Prod
,p.Nombre1
,um.Nombre
,um.NCorto
,l.Cd_Lote
,l.NroLote
,l.FecCaducidad
,l.FecFabricacion

--<Creado: Ja> <13/02/2013>
GO
