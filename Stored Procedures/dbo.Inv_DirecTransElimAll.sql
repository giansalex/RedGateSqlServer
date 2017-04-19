SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_DirecTransElimAll]
@RucE nvarchar(11),
@Cd_Tra char(10),
@msj varchar(100) output
as
begin
begin transaction

	declare @direcs int
	select @direcs = count(*)  from DirecTrans where RucE = @RucE and Cd_Tra = @Cd_Tra
	
	if  @direcs != 0
	begin
		delete from DirecTrans where RucE = @RucE and Cd_Tra = @Cd_Tra
		if @@rowcount <= 0
		begin	   set @msj = 'Direccion no pudo ser eliminada'
		   rollback transaction
		   return
		end
	end
commit transaction
end
print @msj

--MP : 10-03-2011 : <Creacion del procedimiento almacenado>
--select *  from DirecTrans where RucE = '11111111111' and Cd_Tra = 'TRA0001'

GO
