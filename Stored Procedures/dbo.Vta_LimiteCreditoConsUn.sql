SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[Vta_LimiteCreditoConsUn]
@RucE nvarchar(11),
@Cd_Clt char(10),
@msj varchar(100) output
as
if not exists (select * from LimiteCredito where RucE=@RucE and Cd_Clt=@Cd_Clt)
	set @msj = 'Limite de Credito no existe'
else	select a.* from LimiteCredito a where a.RucE=@RucE and a.Cd_Clt=@Cd_Clt
print @msj

GO
