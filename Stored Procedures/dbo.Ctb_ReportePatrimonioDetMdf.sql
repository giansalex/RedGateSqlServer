SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReportePatrimonioDetMdf]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CPtrD nvarchar(5),
@Nombre varchar(100),
@Cd_CPtr varchar(200),
@NroCta varchar(15),
@IB_esTitulo bit,
@Formula varchar(50),
@Estado bit,
@msj varchar(100) output

AS

if not exists (Select * From ReportePatrimonioDet Where RucE=@RucE and Ejer=@Ejer and Cd_CPtrD=@Cd_CPtrD)
	Set @msj = 'No encontró concepto para modificar'
else
begin
	
	update ReportePatrimonioDet set
		Nombre = @Nombre,
		Cd_CPtr = @Cd_CPtr,
		NroCta = @NroCta,
		IB_esTitulo = @IB_esTitulo,
		Formula = @Formula,
		Estado = @Estado
	where RucE=@RucE and Ejer=@Ejer and Cd_CPtrD=@Cd_CPtrD
end

-- Leyenda --
-- DI : 05/12/2012 <Creacion del SP>

GO
