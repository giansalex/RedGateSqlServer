SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipExistenciaCrea]
@CodSNT_ varchar(4),
@Nombre varchar(100),
@NCorto varchar(5),
@Estado bit,
@msj varchar(100) output
as
if exists (select * from TipoExistencia where Nombre=@Nombre)
	set @msj = 'Ya existe un Tipo de Existencia con el nombre ['+@Nombre+']'
else
begin
	insert into TipoExistencia(Cd_TE,CodSNT_,Nombre,NCorto,Estado)
		   Values(user123.Cod_TipoExistencia(),@CodSNT_,@Nombre,@NCorto,1)
	
	if @@rowcount <= 0
	set @msj = 'Tipo de existencia no pudo ser registrada'	
end
print @msj
--J -> 10-04-2010  <Creacion del procedimiento almacenado>
--
GO
