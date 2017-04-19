SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipAuxMdf]
@Cd_TA nvarchar(2),
@Nombre varchar(50),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from TipAux where Cd_TA=@Cd_TA)
	set @msj = 'Tipo Auxiliar no existe'
else
begin
	update TipAux set Nombre=@Nombre, Estado=@Estado
		where Cd_TA=@Cd_TA
	if @@rowcount <= 0
		set @msj = 'Tipo Auxiliar no pudo ser modificado'
end
print @msj
GO
