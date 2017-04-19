SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_LimiteCreditoMdf]
@RucE nvarchar(11),

@Cd_Clt char(10),
--@Id_LC int,
@Max decimal(12,3),
@Min decimal(12,3),
@msj varchar(100) output
as
if not exists (select * from LimiteCredito where RucE=@RucE and Cd_Clt=@Cd_Clt)
	set @msj = 'Limite de credito no existe'
else
begin
	update LimiteCredito set [Max]=@Max,[Min]=@Min
	where RucE=@RucE and Cd_Clt=@Cd_Clt

	if @@rowcount <= 0
	   set @msj = 'Limite de credito no pudo ser modificado'
end
print @msj
GO
