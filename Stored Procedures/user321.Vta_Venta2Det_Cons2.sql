SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Vta_Venta2Det_Cons2]
@RucE nvarchar(11),
@Cd_Vta char(10),
@msj varchar(100) output
as
declare @FecMov datetime
set @FecMov = (select FecMov from venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
select  
vd.RucE,
vd.Cd_Vta,
vd.Nro_RegVdt,
vd.Cant,
vd.Valor,
vd.DsctoP,
vd.DsctoI,
vd.IMP,
vd.IGV,
pu.DescripAlt as UM_,
case(isnull(vd.IGV,0)) when 0 then 0 else 1 end as IncIGV,
vd.Total,
vd.CA01,
vd.CA02,
vd.CA03,
vd.CA04,
vd.CA05,
vd.CA06,
vd.CA07,
vd.CA08,
vd.CA09,
vd.CA10,
vd.Cd_CC,
vd.Cd_SC,
vd.Cd_SS,
vd.Cd_Prod,
vd.Cd_Srv,
Case when Isnull(vd.Cd_Prod,'')='' then s2.CodCo else p2.CodCo1_ end CodCo,
vd.Descrip,
vd.ID_UMP,
vd.PU,
vd.Obs,
vd.Cd_Alm,
vd.Cd_IAV,
case isnull(vd.CU,0) when 0 then dbo.CostSal(@RucE,vd.Cd_Prod,vd.ID_UMP,@FecMov) else vd.CU end as CU,
vd.Costo,
vd.Costo_ME,
case isnull(vd.CU_ME,0) when 0 then 0 else vd.CU_ME end as CU_ME,--vd.CU_ME,
vd.UsuMdfCostoPrm

from VentaDet vd left join Prod_UM pu on vd.RucE = pu.RucE and vd.Cd_Prod = pu.Cd_Prod and vd.ID_UMP = pu.ID_UMP
left join Producto2 p2 on p2.RucE=vd.RucE and p2.Cd_Prod=vd.Cd_Prod
left join Servicio2 s2 on s2.RucE=vd.RucE and s2.Cd_Srv=vd.Cd_Srv
where  vd.RucE = @RucE and vd.Cd_Vta=@Cd_Vta
--exec Vta_Venta2Det_Cons '11111111111','CM00000026',null
-- Leyenda --
-- CAM: 25/08/2012 Creacion
GO
