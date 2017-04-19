SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AlmaConsDir]
@RucE nvarchar(11),
@msj varchar(100) output
as
if ((select count(Direccion) from Almacen where RucE=@RucE and Estado=1)=0)
	Set @msj = 'No se tienen Direcciones de almacen para esta empresa'
else
begin
	select Direccion as Direc,Nombre as Obs from Almacen
	where RucE=@RucE and Estado=1 and len(Direccion)>0
end
print @msj
-- Leyenda --
-- FL : 2011-03-12 : <Creacion del procedimiento almacenado>
GO
