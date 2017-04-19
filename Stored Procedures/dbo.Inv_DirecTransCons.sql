SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_DirecTransCons]
@RucE nvarchar(11),
@Cd_Tra char(10),
@msj varchar(100) output
as
begin
	if not exists (select * from DirecTrans where RucE=@RucE and Cd_Tra = @Cd_Tra)
	set @msj = 'No hay direccion para ese transportista'
	else
	select * from DirecTrans where RucE = @RucE and Cd_Tra = @Cd_Tra and Estado = 1
end
print @msj

-- Leyenda --
-- MP : 2011-03-10 <Creacion del procedimiento almacenado>







GO
