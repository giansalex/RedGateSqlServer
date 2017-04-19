SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocElim]
@Cd_TD nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from TipDoc where Cd_TD=@Cd_TD)
	set @msj = 'Tipo Documento no existe'
else
begin
	delete from TipDoc where Cd_TD=@Cd_TD
	
	if @@rowcount <= 0
	   set @msj = 'Tipo Documento no pudo ser eliminado'
end
print @msj
GO
