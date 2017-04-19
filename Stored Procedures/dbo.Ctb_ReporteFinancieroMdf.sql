SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[Ctb_ReporteFinancieroMdf]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),
@Nombre varchar(100),
@Descrip varchar(200),
@NCorto	nvarchar(10),
@Estado	bit,
@msj varchar(100) output		

AS

if not exists (Select * From ReporteFinanciero Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF)
	Set @msj = 'No se encontro informacion para poder modificar'
else
begin
	Update ReporteFinanciero Set
		Nombre=@Nombre,
		Descrip=@Descrip,
		NCorto=@NCorto,
		Estado=@Estado
	Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF
		                   
	if @@rowcount <= 0
		Set @msj = 'No se pudo modificar reporte financiero'
end

-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>

GO
