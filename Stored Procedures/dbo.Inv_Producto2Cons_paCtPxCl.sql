SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paCtPxCl] -- Consulta de Productos x Clase para Cartera de Productos
@RucE nvarchar(11),
@Cd_CL char(3),
@Cd_CLS char(3),
@Cd_CLSS char(3),
@msj varchar(100) output
as
/*declare @check bit
set @check=0*/

if(@Cd_CLS='' and @Cd_CLSS='' or @Cd_CLS is null and @Cd_CLSS is null)
begin
	select /*@check as Sel,*/Cd_Prod as Codigo,Nombre1 as Nombre
	from Producto2 
	where RucE = @RucE and Cd_CL=@Cd_CL
end
else if(@Cd_CLSS='' or @Cd_CLSS is null)
begin
	select /*@check as Sel,*/Cd_Prod as Codigo,Nombre1 as Nombre
	from Producto2 
	where RucE = @RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS
end
else
begin
	select /*@check as Sel,*/Cd_Prod as Codigo,Nombre1 as Nombre
	from Producto2 
	where RucE = @RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS and Cd_CLSS=@Cd_CLSS
	
end
print @msj
-- Leyenda --
-- J : 2010-03-24 : <Creacion del procedimiento almacenado>
GO
