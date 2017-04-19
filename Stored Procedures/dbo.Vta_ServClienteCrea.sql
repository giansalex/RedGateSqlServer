SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_ServClienteCrea] -- <Procedimiento que registra ServCliente>
@RucE nvarchar(11),
@ID_ServClt int output,
@Cd_Clt char(10),
@Cd_Srv char(7),
@Precio decimal(13,2),
@IB_IncIGV bit,
@Cd_Mda nvarchar(2),
@Estado bit,
@msj varchar(100) output
as
set @ID_ServClt = dbo.ID_ServClt(@RucE)
if exists (select * from ServCliente where RucE=@RucE and ID_ServClt=@ID_ServClt)
	set @msj = 'Este cliente ya tiene registrado este servicio'
else
begin
	insert into ServCliente(RucE,ID_ServClt,Cd_Clt,Cd_Srv,Precio,IB_IncIGV,Cd_Mda,Estado)
	values(@RucE,@ID_ServClt,@Cd_Clt,@Cd_Srv,@Precio,@IB_IncIGV,@Cd_Mda,@Estado)	
	
	if @@rowcount <= 0
	set @msj = 'Servicio no se asocio correctamente al Cliente'	
end
-- Leyenda --
-- MP : 2012-10-21 : <Creacion del procedimiento almacenado>
print @msj
GO
