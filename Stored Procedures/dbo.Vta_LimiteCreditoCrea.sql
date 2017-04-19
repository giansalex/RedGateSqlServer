SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_LimiteCreditoCrea]
@RucE nvarchar(11),

@Cd_Clt char(10),
@Max decimal(12,3),
@Min decimal(12,3),
@msj varchar(100) output
as
declare @Id int
set @Id = dbo.Id_LC(@RucE);

if exists (select * from LimiteCredito where RucE=@RucE and Cd_Clt=@Cd_Clt and Id_LC=@Id)
	set @msj = 'Limite de Credito ya existe'
else
begin
	insert into LimiteCredito (RucE,Cd_Clt,Id_LC,[Max],[Min])
		  values(@RucE,@Cd_Clt,@Id,@Max,@Min)
	
	if @@rowcount <= 0
		set @msj = 'Limite de Credito no pudo ser ingresado'
end
print @msj
GO
