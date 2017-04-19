SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AlmaMdf1]
@RucE nvarchar(11),
@Cd_Alm varchar(20),
@Codigo varchar(15),
@Nombre varchar(50),
@NCorto varchar(5),
@Ubigeo nvarchar(6),
@Direccion varchar(100),
@Encargado varchar(100),
@Telef varchar(15),
@Capacidad varchar(30),
@Obs varchar(200),
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@msj varchar(100) output,
@IB_EsVI bit
as
if not exists (select * from Almacen where Cd_Alm=@Cd_Alm)
	set @msj = 'Almacen no existe'
else
begin
	update Almacen set Codigo=@Codigo,Nombre=@Nombre,NCorto=@NCorto,Ubigeo=@Ubigeo,Direccion=@Direccion,
		Encargado=@Encargado,Telef=@Telef,Capacidad=@Capacidad,Obs=@Obs,Estado =@Estado,
		CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05,IB_EsVI=@IB_EsVI
where Cd_Alm=@Cd_Alm and RucE = @RucE
	
	if @@rowcount <= 0
	set @msj = 'Almacen no pudo ser modificado'	
end
print @msj

-- Leyenda --
-- PP : 2010-02-12 : <Creacion del procedimiento almacenado>
GO
