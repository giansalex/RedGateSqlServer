SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Prd_OrdProduccion_ConsUn]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as if not exists (select * from OrdFabricacion where RucE=@RucE and Cd_OF=@Cd_OF)
	set @msj = 'No existe Orden de Produccion'
else
begin
	select	* from OrdFabricacion 
	where RucE=@RucE and Cd_OF=@Cd_OF
end
-- Leyenda --
-- FL : 27/02/11 : <Creacion del procedimiento almacenado>

GO
