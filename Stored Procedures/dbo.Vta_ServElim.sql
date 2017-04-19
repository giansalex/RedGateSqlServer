SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ServElim]
@RucE nvarchar(11),
@Cd_Srv nvarchar(7),
@msj varchar(100) output
as
Declare @Cd_Pro nvarchar(10)
if not exists (select * from Servicio where RucE=@RucE and Cd_Srv=@Cd_Srv)
	set @msj = 'Servicio no existe'
else
begin transaction
	if exists (select * from VentaDet where  RucE=@RucE and Cd_Pro=@Cd_Srv)
	begin
		set @msj = 'Servicio tiene información vinculada. No puede ser eliminado'
		rollback transaction
		return
	end
	delete from Servicio where RucE=@RucE and Cd_Srv=@Cd_Srv 
	if @@rowcount <= 0
	begin
		set @msj = 'Servicio no pudo ser eliminado'
		rollback transaction
		return
	end

	delete from Producto where RucE=@RucE and Cd_Pro=@Cd_Srv
	
	if @@rowcount <= 0
	begin
		set @msj = 'Producto no pudo ser eliminado'
		rollback transaction
		return
	end
commit transaction
print @msj
--PV: MIE 11/02/09
GO
