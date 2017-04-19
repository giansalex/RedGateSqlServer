SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Vta_Venta2Det_Cons]
@RucE nvarchar(11),
@Cd_Vta char(10),
@msj varchar(100) output
as
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
vd.Descrip,
vd.ID_UMP,
vd.PU,
vd.Obs,
vd.Cd_Alm,
vd.Cd_IAV

from VentaDet vd left join Prod_UM pu on vd.RucE = pu.RucE and vd.Cd_Prod = pu.Cd_Prod and vd.ID_UMP = pu.ID_UMP
where  vd.RucE = @RucE and vd.Cd_Vta=@Cd_Vta
--exec Vta_Venta2Det_Cons '11111111111','CM00000026',null
-- Leyenda --
-- JJ : 2010-08-24 : <Creacion del procedimiento almacenado>
-- JU : 2010-09-08 : <Actualizacion del procedimiento almacenado>
GO
