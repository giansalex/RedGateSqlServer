SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CajaCrea]
@RucE nvarchar(11),
@Cd_Caja nvarchar(20) output,
@Nombre varchar(50),
@Numero nvarchar(100),
@Cd_Area nvarchar(12),
@Estado bit,
@msj varchar(100) output
as
if exists (select * from Caja where RucE=@RucE and Cd_Caja=@Cd_Caja)
	set @msj = 'Caja ya existe'
else
begin
	set @Cd_Caja = dbo.Cod_Caja(@RucE)
	insert into Caja(RucE,Cd_Caja,Nombre,Numero,Cd_Area,Estado)
		  values(@RucE,@Cd_Caja,@Nombre,@Numero,@Cd_Area,@Estado)
	
	if @@rowcount <= 0
		set @msj = 'Caja no pudo ser ingresado'
end
print @msj

--MP : 03/02/2012 : <Creacion del procedimiento almacenado>
GO
