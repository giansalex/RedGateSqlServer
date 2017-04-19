SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_DirecEntCons]
@RucE nvarchar(11),
@Cd_Clt char(10),
@msj varchar(100) output
as
begin
	if not exists (select * from DirecEnt where RucE=@RucE and Cd_Clt = @Cd_Clt)
	set @msj = 'No hay direccion para ese cliente'
	else
	select * from DirecEnt where RucE = @RucE and Cd_Clt = @Cd_Clt and Estado = 1
end
print @msj

-- Leyenda --
-- MP : 2011-03-14 : <Creacion del procedimiento almacenado>









GO
