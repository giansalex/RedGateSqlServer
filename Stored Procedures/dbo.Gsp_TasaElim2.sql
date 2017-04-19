SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Gsp_TasaElim2]
@Cd_Ts nvarchar(3),
@msj varchar(100) output
as

Declare @Fecha nchar(20)
set @Fecha = (select MAX(EjerPrdoVig) from TasasHist where Cd_Ts=@Cd_Ts)
 

if not exists (select MAX(EjerPrdoVig) from TasasHist where Cd_Ts=@Cd_Ts)
	set @msj = 'Tasa no existe'
else
begin
	delete from TasasHist where Cd_Ts=@Cd_Ts and EjerPrdoVig=@Fecha
	
	if @@rowcount <= 0
	   set @msj = 'Tasa no pudo ser eliminado'
end
print @msj
GO
