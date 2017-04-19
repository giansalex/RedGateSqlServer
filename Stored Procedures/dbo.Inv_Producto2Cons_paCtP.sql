SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paCtP] --Para Cartera de Productos
@RucE nvarchar(11),
@msj varchar(100) output
as
/*declare @check bit
set @check=0*/
	select /*@check as Sel,*/Cd_Prod as Codigo,Nombre1 as Nombre, codCo1_
	from Producto2 
	where RucE = @RucE
print @msj
-- Leyenda --
-- J : 2010-03-24 : <Creacion del procedimiento almacenado>
GO
