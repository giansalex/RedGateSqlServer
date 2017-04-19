SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipAuxCrea]
--@Cd_TA nvarchar(2),
@Nombre varchar(50),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from TipAux where Nombre=@Nombre)
	set @msj = 'Tipo Auxiliar ya existe'
else
begin
	insert into TipAux(Cd_TA,Nombre,Estado)
		  values(user123.Cod_TA(),@Nombre,1)
	
	if @@rowcount <= 0
		set @msj = 'Tipo Auxiliar no pudo ser ingresado'
end
print @msj
GO
