SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReportePatrimonioMdf]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CPtr nvarchar(5),
@Nombre varchar(100),
@NCorto varchar(10),
@Estado bit,
@msj varchar(100) output

AS
if not exists (Select * From ReportePatrimonio Where RucE=@RucE and Ejer=@Ejer and Cd_CPtr=@Cd_CPtr)
	Set @msj = 'No encontró concepto para modificar'
else if exists (Select * From ReportePatrimonio Where RucE=@RucE and Ejer=@Ejer and Cd_CPtr<>@Cd_CPtr and Nombre=@Nombre)
	Set @msj = 'Existe otro registro con el mismo nombre ingresado'
else if exists (Select * From ReportePatrimonio Where RucE=@RucE and Ejer=@Ejer and Cd_CPtr<>@Cd_CPtr and NCorto=@NCorto)
	Set @msj = 'Existe otro registro con el mismo nombre corto ingresado'
else
begin
	
	update ReportePatrimonio set
		Nombre = @Nombre,
		NCorto = @NCorto,
		Estado = @Estado
	where RucE=@RucE and Ejer=@Ejer and Cd_CPtr=@Cd_CPtr
end

-- Leyenda --
-- DI : 30/11/2012 <Creacion del SP>
GO
