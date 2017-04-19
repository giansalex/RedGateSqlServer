SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AlmaCrea]
@RucE nvarchar(11),
--@Cd_alm varchar(20),
@Codigo varchar(15),
@Nombre varchar(50),
@NCorto varchar(5),
@Ubigeo nvarchar(6),
@Direccion varchar(100),
@Encargado varchar(100),
@Telef varchar(15),
@Capacidad varchar(30),
@Obs varchar(200),
--@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@Padre nvarchar(20),
@msj varchar(100) output,
@Cod_Alm varchar(20) output
as
if exists (select * from Almacen where RucE=@RucE and Nombre=@Nombre)
	set @msj = 'Ya existe un Almancen con el nombre ['+@Nombre+']'
else
	begin
		if exists (select * from Almacen where RucE=@RucE and Codigo=@Codigo)
			set @msj = 'Ya existe un Almancen con el codigo ['+@Codigo+']'
		else
			begin
				set @Cod_Alm = dbo.Cod_Alm(@RucE , @Padre)
				insert into Almacen(RucE,Cd_Alm,Codigo,Nombre,NCorto,Ubigeo,Direccion,Encargado,Telef,Capacidad,Obs,Estado,CA01,CA02,CA03,CA04,CA05)
				   values(@RucE,@Cod_Alm,@Codigo,@Nombre,@NCorto,@Ubigeo,@Direccion,@Encargado,@Telef,@Capacidad,@Obs,1,@CA01,@CA02,@CA03,@CA04,@CA05)
				if @@rowcount <= 0
					set @msj = 'Almacen no pudo ser registrado'	
			end
	end
print @msj
-- Leyenda --
-- PP : 2010-02-12 : <Creacion del procedimiento almacenado>
--J : 2010-12-01 : <Se agrego --> RucE=@RucE >
-- MP : 18-02-2011 : <Modificacion del procedimiento almacenado>
-- MP : 16-03-2011 : <Modificacion del procedimiento almacenado>





GO
