SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMCons_paSRSC]
--<Procedimiento almacenado que consulta los productos por U.M. para Solicitud de Compra>--
@RucE nvarchar(11),
@msj varchar(100) output
as

declare @check bit
set @check=0
declare @cant decimal(13,3)
set @cant = 1

select distinct @check as Sel,p.Cd_Prod,p.Nombre1 as NomProd,@cant as Cant,p.Descrip as DescripC,
		cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase
from Producto2 p 
left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
inner join prod_um pum on pum.Cd_Prod=p.Cd_Prod and pum.RucE=p.RucE

where p.RucE = @RucE 
--and pum.RucE+pum.Cd_Prod+convert(nvarchar,pum.ID_UMP) not in (select RucE+Cd_Prod+convert(nvarchar,ID_UMP) from prodprov  where RucE = @RucE)

-- Leyenda --
--M : 02/12/2010 <Creacion del procedimiento almacenado>\
--PP : 04/02/2010 Mfd : <modificado a pedido de emer con  el fin de  no filtrar por  proveedor>
--exec dbo.Inv_ProdUMCons_SC '11111111111', null










GO
