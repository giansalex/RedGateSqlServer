SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_UndMedElim]
@Cd_UM nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from UnidadMedida where Cd_UM=@Cd_UM)
	set @msj = 'Unidad de medidad no existe'
else
begin
	delete from UnidadMedida where Cd_UM=@Cd_UM
	
	if @@rowcount <= 0
	set @msj = 'Unidad medida no pudo ser eliminado'	
end
print @msj
GO
