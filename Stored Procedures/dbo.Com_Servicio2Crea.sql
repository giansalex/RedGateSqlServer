SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Servicio2Crea]
@RucE nvarchar(11),
@Nombre varchar(100),
@UsuCrea varchar(50),
@msj varchar(100) output
as
if exists (select * from Servicio2 where RucE=@RucE and Nombre=@Nombre)
	set @msj = 'Ya existe ese Servicio'
else
begin
	insert into Servicio2(RucE,Cd_Srv,Nombre,IC_TipServ,Usucrea,FecReg,Estado)
		    values(@RucE,user123.Cod_Srv2Com(@RucE),@Nombre,'c',@UsuCrea,getdate(),1)
	
	if @@rowcount <= 0
	   set @msj = 'El Servicio no pudo ser creado'
end
print @msj
GO
