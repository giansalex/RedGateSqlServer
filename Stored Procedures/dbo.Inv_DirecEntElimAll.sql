SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_DirecEntElimAll]
@RucE nvarchar(11),
@Cd_Clt char(10),
@msj varchar(100) output
as
begin
begin transaction

	declare @direcs int
	select @direcs = count(*)  from DirecEnt where RucE = @RucE and Cd_Clt = @Cd_Clt
	
	if  @direcs != 0
	begin
		delete from DirecEnt where RucE = @RucE and Cd_Clt = @Cd_Clt
		if @@rowcount <= 0
		begin	   set @msj = 'Direccion no pudo ser eliminada'
		   rollback transaction
		   return
		end
	end
commit transaction
end
print @msj

--MP : 14-03-2011 : <Creacion del procedimiento almacenado>
--select *  from DirecEnt where RucE = '11111111111' and Cd_Clt = 'CLT0000002'



GO
