SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ServProvElim]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_SP char(6),
@msj varchar(100) output
as
if not exists (select * from ServProv where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_SP=@Cd_SP)
	set @msj = 'Servicio no existe'
else
begin
	delete from ServProv where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_SP=@Cd_SP
	
	if @@rowcount <= 0
	set @msj = 'Servicio no pudo ser eliminado'	
end
print @msj
-- Leyenda --
-- FL : 2010-08-26 : <Creacion del procedimiento almacenado>
GO
