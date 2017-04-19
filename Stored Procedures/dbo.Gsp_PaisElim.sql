SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Gsp_PaisElim]
@Cd_Pais nvarchar(8),
@msj varchar(100) output
as
if not exists (select * from Pais where @Cd_Pais=@Cd_Pais)
	set @msj = 'Pais no existe'
else
begin
	delete from Pais
	where Cd_Pais=@Cd_Pais
	
	if @@rowcount <= 0
	   set @msj = 'Pais no pudo ser eliminado'
end
print @msj

--bg 25/02/2013: sp elimina pais
GO
