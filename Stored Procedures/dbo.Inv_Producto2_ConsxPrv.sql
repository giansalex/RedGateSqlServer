SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2_ConsxPrv]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output

as

declare @cant decimal(13,3)
set @cant = 1


declare @descrip varchar(100)
set @descrip = ''

select
	pp.Cd_Prod,p.Nombre1 as NomProd,ump.ID_UMP,ump.DescripAlt as descpum,@cant as Cant,@descrip as DescripC,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,pp.CodigoAlt,pp.DescripAlt,Obs,pp.Estado,pp.CA01,pp.CA02,pp.CA03
from ProdProv pp
left join Producto2 p On p.RucE=pp.RucE and p.Cd_Prod=pp.Cd_Prod

left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
left join Prod_UM ump On ump.RucE=pp.RucE and ump.ID_UMP=pp.ID_UMP and ump.Cd_Prod = pp.Cd_Prod
where pp.Cd_Prv=@Cd_Prv and pp.RucE=@RucE 
-- Leyedan --
--FL : 10/08/2010 <Creacion del procedimiento almacenado>





GO
