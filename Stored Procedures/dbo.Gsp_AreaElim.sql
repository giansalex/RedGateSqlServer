SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_AreaElim]
@RucE nvarchar(11),
@Cd_Area nvarchar(6),
@msj varchar(100) output
as
if not exists (select * from Area where RucE=@RucE and Cd_Area=@Cd_Area)
	set @msj = 'Area no existe'
else
begin
	if exists (select * from Venta where RucE=@RucE and Cd_Area=@Cd_Area)
	begin
		set @msj = 'Area no puede ser eliminada por estar enlazada a informacion de ventas'
		return
	end
	
	delete Area Where RucE=@RucE and Cd_Area=@Cd_Area
	
	if @@rowcount <= 0
		set @msj = 'Area no pudo ser eliminado'
end
print @msj
GO
