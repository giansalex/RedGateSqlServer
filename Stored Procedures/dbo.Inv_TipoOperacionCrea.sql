SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipoOperacionCrea] --<Procemiento que crea los tipos de operaciones p.ej. Input,Output>
@CodSNT_ varchar(4),
@Nombre varchar(100),
@NCorto varchar(5),
@msj varchar(100) output
as
if exists (select * from TipoOperacion where Nombre=@Nombre)
	set @msj = 'Ya existe un Tipo de Operación con el nombre ['+@Nombre+']'
else
begin
	insert into TipoOperacion(Cd_TO,CodSNT_,Nombre,NCorto,Estado)
	values(user123.Cod_TO(),@CodSNT_,@Nombre,@NCorto,1)	
	
	if @@rowcount <= 0
	set @msj = 'Tipo de Operación no pudo ser registrado'	
end
--J -> 10-04-2010  <Creacion del procedimiento almacenado>
GO
