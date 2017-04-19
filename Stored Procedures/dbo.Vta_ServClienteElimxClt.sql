SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Vta_ServClienteElimxClt]
@RucE nvarchar(11),
@Cd_Clt char(10),
@msj varchar(100) output
as

if not exists (select * from ServCliente where RucE=@RucE and Cd_Clt=@Cd_Clt)
	set @msj = 'Servicio no existe'
else
begin transaction
	
	delete from ServCliente where RucE=@RucE and Cd_Clt=@Cd_Clt 
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
