SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReportePatrimonioElim]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CPtr nvarchar(5),
@msj varchar(100) output

AS


if not exists (Select * From ReportePatrimonio where RucE=@RucE and Ejer=@Ejer and Cd_CPtr=@Cd_CPtr)
	Set @msj = 'No se encontro concepto con el codigo '+@Cd_CPtr
else if exists (Select * From ReportePatrimonioDet where RucE=@RucE and Ejer=@Ejer and Cd_CPtr like '%'+@Cd_CPtr+'%')
	Set @msj = 'No se puede eliminar concepto, esta asociado con otros registro'
else
begin
	delete from ReportePatrimonio where RucE=@RucE and Ejer=@Ejer and Cd_CPtr=@Cd_CPtr
	
	if @@ROWCOUNT <= 0
	begin
		Set @msj = 'Hubo error al eliminar concepto Estados de Cambio de Patrimonio Neto'
	end
end

-- Leyenda --
-- DI : 13/12/2012 <Creacion del SP>

GO
