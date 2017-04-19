SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_LimiteCreditoElim]
@RucE nvarchar(11),
@Cd_Clt char(10),
--@Id_LC int,
@msj varchar(100) output
as
if not exists (select * from LimiteCredito where RucE=@RucE and Cd_Clt=@Cd_Clt)
	set @msj = 'Limite de Credito no existe'
else
begin
	delete from LimiteCredito where RucE=@RucE and Cd_Clt=@Cd_Clt
	if @@rowcount <= 0
	   set @msj = 'Limite de Credito no pudo ser eliminado'
end
print @msj
GO
