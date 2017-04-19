SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_DirecEntElim]
@RucE nvarchar(11),
@Cd_Clt char(10),
@Item int,
@msj varchar(100) output
as
begin
begin transaction
	delete from DirecEnt where RucE = @RucE and Cd_Clt = @Cd_Clt and Item = @Item
	if @@rowcount <= 0
	begin	   set @msj = 'Direccion no pudo ser eliminada'
	   rollback transaction
	   return
	end
commit transaction
end
print @msj
GO
