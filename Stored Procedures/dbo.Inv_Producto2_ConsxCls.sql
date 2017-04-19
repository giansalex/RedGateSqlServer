SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2_ConsxCls]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output

as

declare @check bit
set @check=0

declare @cant decimal(13,3)
set @cant = 1


declare @descrip varchar(100)
set @descrip = ''

select 
	@check as Sel,p.Cd_Prod,p.Nombre1 as NomProd,@cant as Cant,@descrip as DescripC,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase

from Producto2 p 

left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
where p.Cd_Prod not in ( select Cd_ProdB from ProdCombo where Cd_ProdC = @Cd_Prod ) and p.Cd_Prod <> isnull(@Cd_Prod,'') and p.RucE=@RucE  and p.Estado =1
-- Leyedan --
--DI : 24/02/2010 <Creacion del procedimiento almacenado>
--PP : 2010-03-10 12:09:36 <Modificacion del procedimiento almacenado>
--PP : 2011-02-22 12:09:36 <Modificacion del procedimiento almacenado en el join>






GO
