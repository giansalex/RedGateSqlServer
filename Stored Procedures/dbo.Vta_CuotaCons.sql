SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CuotaCons]
@RucE nvarchar(11),
@Cd_EC int,
@msj varchar(100) output

as

begin
	if exists (select * from Cuota where RucE = @RucE and Cd_EC=@Cd_EC)
		select * from Cuota where RucE = @RucE and Cd_EC=@Cd_EC
	else
		set @msj = 'No hay registros de Cuotas'
end
print @msj



-- Leyenda --
-- MP : 2011-05-27 : <Creacion del procedimiento almacenado>

GO
