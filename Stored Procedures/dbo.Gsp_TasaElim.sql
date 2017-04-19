SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TasaElim]
@Cd_Ts nvarchar(3),
@msj varchar(100) output
as
if not exists (select * from Tasas where Cd_Ts=@Cd_Ts)
	set @msj = 'Tasa no existe'
else
begin
	delete from Tasas where Cd_Ts=@Cd_Ts
	
	if @@rowcount <= 0
	   set @msj = 'Tasa no pudo ser eliminado'
end
print @msj
GO
