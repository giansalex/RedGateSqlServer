SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ServClienteElim]
@RucE nvarchar(11),
@ID_ServClt int,
@msj varchar(100) output
as

if not exists (select * from ServCliente where RucE=@RucE and ID_ServClt=@ID_ServClt)
	set @msj = 'Servicio no existe'
else
begin transaction
	
	delete from ServCliente where RucE=@RucE and ID_ServClt=@ID_ServClt 
	if @@rowcount <= 0
	begin
		set @msj = 'Servicio no pudo ser eliminado'
		rollback transaction
		return
	end
commit transaction
print @msj

--MP: 11/02/09 : <Creacion del procedimiento almacenado>
GO
