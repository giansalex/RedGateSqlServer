SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReportePatrimonioDetElim]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CPtrD nvarchar(5),
@msj varchar(100) output

AS


if not exists (Select * From ReportePatrimonioDet where RucE=@RucE and Ejer=@Ejer and Cd_CPtrD=@Cd_CPtrD)
	Set @msj = 'No se encontro concepto detalle con el codigo '+@Cd_CPtrD
else
begin
	delete from ReportePatrimonioDet where RucE=@RucE and Ejer=@Ejer and Cd_CPtrD=@Cd_CPtrD
	
	if @@ROWCOUNT <= 0
	begin
		Set @msj = 'Hubo error al eliminar concepto Detalle Estados de Cambio de Patrimonio Neto'
	end
end

-- Leyenda --
-- DI : 13/12/2012 <Creacion del SP>

GO
