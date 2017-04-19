SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_UniMedCons]
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from UnidadMedidad)
	set @msj = 'Unidad de Medidad no se encontro'
else  */
begin
	if(@TipCons=0)
		select * from UnidadMedida
	else select Cd_UM+'  |  '+Nombre as CodNom, Cd_UM,Nombre from UnidadMedida where Estado=1
end
print @msj
GO
