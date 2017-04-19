SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_UndMedCrea]
--@Cd_UM nvarchar(2),
@CodSNT_ varchar(2),
@Nombre varchar(50),
@NCorto varchar(5),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from UnidadMedida where Nombre=@Nombre)
	set @msj = 'Ya existe una unidad medida con el nombre ['+@Nombre+']'
else
begin
	insert into UnidadMedida(Cd_UM,CodSNT_,Nombre,NCorto,Estado)
		   Values(user123.Cod_UM(),@CodSNT_,@Nombre,@NCorto,1)
	
	if @@rowcount <= 0
	set @msj = 'Unidad medida no pudo ser registrado'	
end
print @msj

GO
