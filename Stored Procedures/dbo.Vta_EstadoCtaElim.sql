SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Vta_EstadoCtaElim]
@RucE nvarchar(11),
@Cd_EC int,
@msj varchar(100) output
as

if not exists (select * from EstadoCta where RucE = @RucE and Cd_EC=@Cd_EC)
	set @msj = 'Estado de Cta. no existe'
else
begin
begin transaction	
		delete from EstadoCta where RucE = @RucE and Cd_EC= @Cd_EC
		
		if @@rowcount <= 0
		begin			set @msj = 'Estado de Cta. no pudo ser eliminado'
			rollback transaction
			return
		end
commit transaction
end
print @msj


-- MP: 25/05/2011 : <Modificacion del procedimiento almacenado>
GO
