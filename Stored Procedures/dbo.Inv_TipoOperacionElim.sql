SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipoOperacionElim]--<Procemiento que elimina los tipos de operaciones p.ej. Input,Output>
@Cd_TO nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from TipoOperacion where Cd_TO=@Cd_TO)
	set @msj = 'Tipo de Operación no existe'
else
begin
	delete from TipoOperacion where Cd_TO=@Cd_TO

	if @@rowcount <= 0
	set @msj = 'Tipo de Operación no pudo ser eliminado'	
end

GO
