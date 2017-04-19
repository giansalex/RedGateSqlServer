SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_ServClienteMdf] -- <Procedimiento que registra ServCliente>
@RucE nvarchar(11),
@ID_ServClt int,
@Cd_Clt char(10),
@Cd_Srv char(7),
@Precio decimal(13,2),
@IB_IncIGV bit,
@Cd_Mda nvarchar(2),
@Estado bit,
@msj varchar(100) output
as

begin
	update ServCliente
	set Precio=@Precio,IB_IncIGV=@IB_IncIGV,Cd_Mda=@Cd_Mda,Estado=@Estado
	where RucE=@RucE and ID_ServClt=@ID_ServClt
	
	if @@rowcount <= 0
	set @msj = 'Servicio no se actualizo correctamente'	
end
-- Leyenda --
-- MP : 2012-10-21 : <Creacion del procedimiento almacenado>
print @msj
GO
