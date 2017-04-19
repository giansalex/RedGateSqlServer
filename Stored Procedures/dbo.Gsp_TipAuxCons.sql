SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipAuxCons]
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from TipoAux)
	set @msj = 'No se encontro Tipo Auxiliar'
else*/
begin
	if(@TipCons=0)
		select * from TipAux
	else select Cd_TA+'  |  '+Nombre as CodNom, Cd_TA,Nombre  from TipAux where Estado=1
end
print @msj
GO
