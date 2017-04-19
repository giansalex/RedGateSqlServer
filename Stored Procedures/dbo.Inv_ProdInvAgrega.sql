SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdInvAgrega]
@RucE nvarchar(11),
@msj varchar(100) output
as
declare @check bit
set @check=0

declare @cant decimal(13,3)
set @cant = 1
declare @Maximo decimal(13,3)
set @Maximo = 999999.999

select distinct
	@check as Sel,p.Cd_Prod,p.Nombre1 as NomProd,@cant as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase, @Maximo as Maximo
from Producto2 p 

left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and cc.Cd_CL=p.Cd_CL
left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and sc.Cd_CLS=p.Cd_CLS and cc.Cd_CL=p.Cd_CL
left join prod_um pum on pum.Cd_Prod=p.Cd_Prod and pum.RucE=p.RucE

where p.RucE = @RucE and p.estado=1
-- Leyenda --
-- FL : 2010-11-10 : <modificacion del sp, tenia creador fantasma>
-- PP : 2011-02-22 :  modificacion  en el  join!



GO
