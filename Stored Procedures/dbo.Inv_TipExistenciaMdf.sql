SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipExistenciaMdf]
@Cd_TE char(2),
@CodSNT_ varchar(4),
@Nombre varchar(100),
@NCorto varchar(5),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from TipoExistencia where Cd_TE=@Cd_TE)
	set @msj = 'Tipo de Existencia no encontrada'
else
begin
	update TipoExistencia set CodSNT_=@CodSNT_,Nombre=@Nombre, NCorto=@NCorto,Estado=@Estado
	where Cd_TE=@Cd_TE

	if @@rowcount <= 0
	set @msj = 'Tipo de Existencia no pudo ser modificado'	
end

GO
