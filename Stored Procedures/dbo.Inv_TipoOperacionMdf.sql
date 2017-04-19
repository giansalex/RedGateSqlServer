SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipoOperacionMdf] --<Procemiento que modifica los tipos de operaciones p.ej. Input,Output>
@Cd_TO nvarchar(2),
@CodSNT_ varchar(4),
@Nombre varchar(100),
@NCorto varchar(5),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from TipoOperacion where Cd_TO=@Cd_TO)
	set @msj = 'Tipo de Operación no existe'
else
begin
	update TipoOperacion set CodSNT_=@CodSNT_,Nombre=@Nombre, NCorto=@NCorto, Estado=@Estado
	where Cd_TO=@Cd_TO

	if @@rowcount <= 0
	set @msj = 'Tipo de Operación no pudo ser modificado'	
end
--J -> 10-04-2010  <Creacion del procedimiento almacenado>
GO
