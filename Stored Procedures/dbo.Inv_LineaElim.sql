SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_LineaElim]
@Cd_Ln nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from Linea where Cd_Ln=@Cd_Ln)
	set @msj = 'Linea no existe'
else
begin
	delete from Linea where Cd_Ln=@Cd_Ln
	
	if @@rowcount <= 0
	set @msj = 'Linea no pudo ser eliminado'	
end
print @msj
GO
