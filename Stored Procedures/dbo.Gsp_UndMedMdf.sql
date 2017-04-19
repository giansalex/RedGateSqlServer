SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_UndMedMdf]
@Cd_UM nvarchar(2),
@CodSNT_ varchar(2),
@Nombre varchar(50),
@NCorto varchar(5),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from UnidadMedida where Cd_UM=@Cd_UM)
	set @msj = 'Unidad de medidad no existe'
else
begin
	update UnidadMedida set CodSNT_ = @CodSNT_, Nombre=@Nombre, NCorto=@NCorto, 
                                Estado=@Estado
	where Cd_UM=@Cd_UM
	
	if @@rowcount <= 0
	set @msj = 'Unidad medida no pudo ser modificado'	
end
print @msj


GO
