SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReportePatrimonioCrea]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Nombre varchar(100),
@NCorto varchar(10),
@Estado bit,
@msj varchar(100) output

AS

if exists (Select * From ReportePatrimonio Where RucE=@RucE and Ejer=@Ejer and Nombre=@Nombre)
	Set @msj = 'Existe otro registro con el mismo nombre ingresado'
else if exists (Select * From ReportePatrimonio Where RucE=@RucE and Ejer=@Ejer and NCorto=@NCorto)
	Set @msj = 'Existe otro registro con el mismo nombre corto ingresado'
else
begin

	Declare @Cd_CPtr nvarchar(5) Set @Cd_CPtr=''
	Set @Cd_CPtr = (Select right('00000'+ltrim(Convert(int,isnull(Max(Cd_CPtr),'00000'))+1),5) From ReportePatrimonio Where RucE=@RucE and Ejer=@Ejer)
	
	insert into ReportePatrimonio(RucE,Ejer,Cd_CPtr,Nombre,NCorto,Estado)
	values(@RucE,@Ejer,@Cd_CPtr,@Nombre,@NCorto,@Estado)
	
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al registrar concepto de Estados de Cambio de Patrimonio Neto'
	end
end

-- Leyenda --
-- DI : 30/11/2012 <Creacion del SP>

GO
