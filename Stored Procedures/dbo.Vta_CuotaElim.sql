SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Vta_CuotaElim]
@RucE nvarchar(11),
@Cd_EC int,
@Cd_Cuo int,
@msj varchar(100) output
as

if not exists (select * from Cuota where RucE = @RucE and Cd_EC=@Cd_EC and Cd_Cuo=@Cd_Cuo)
	set @msj = 'Cuota no existe'
else
begin
begin transaction	
		delete from Cuota where RucE = @RucE and Cd_EC= @Cd_EC and Cd_Cuo=@Cd_Cuo
		
		if @@rowcount <= 0
		begin			set @msj = 'Cuota no pudo ser eliminado'
			rollback transaction
			return
		end
commit transaction
end
print @msj


-- MP: 27/05/2011 : <Modificacion del procedimiento almacenado>
GO
