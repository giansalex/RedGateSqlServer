SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_UndMedCons]
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from UnidadMedida)
	set @msj = 'No se encontro Unidad de medidad'
else*/
begin
	--Consulta general--
	if(@TipCons=0)
	begin
		select  Cd_UM,CodSNT_,Nombre,NCorto,Estado from UnidadMedida
	end
		--Consulta para el comobox con estado=1--
		else if(@TipCons=1)
		begin
			select Cd_UM+'  |  '+Nombre,Cd_UM,Nombre from UnidadMedida where Estado=1
		end
			--Consulta general con estado=1--
			else if(@TipCons=2)
			begin
				select Cd_UM,Nombre,NCorto,Estado from UnidadMedida where Estado=1
			end
				--Consulta para la ayuda con estado=1--
				else if(@TipCons=3)
				begin
					select Cd_UM,Cd_UM, Nombre from UnidadMedida where Estado=1
					--select Nombre from UnidadMedida where Estado=1
				end

end
print @msj
GO
