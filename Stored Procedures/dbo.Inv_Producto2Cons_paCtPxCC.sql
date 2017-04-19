SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paCtPxCC] -- Consulta de Productos x C.Costos para Cartera de Productos
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@msj varchar(100) output
as
/*declare @check bit
set @check=0*/

if(@Cd_SC='' and @Cd_SS='' or @Cd_SC is null and @Cd_SS is null)
begin
	select /*@check as Sel,*/Cd_Prod as Codigo,Nombre1 as Nombre
	from Producto2 
	where RucE = @RucE and Cd_CC=@Cd_CC
end
else if(@Cd_SS='' or @Cd_SS is null)
begin
	select /*@check as Sel,*/Cd_Prod as Codigo,Nombre1 as Nombre
	from Producto2 
	where RucE = @RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC
end
else
begin
	select /*@check as Sel,*/Cd_Prod as Codigo,Nombre1 as Nombre
	from Producto2 
	where RucE = @RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS
	
end
print @msj
-- Leyenda --
-- J : 2010-03-24 : <Creacion del procedimiento almacenado>
GO
