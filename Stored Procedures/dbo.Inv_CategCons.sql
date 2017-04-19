SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CategCons]
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
		select Cd_Cat,Nombre,NCorto,Estado from Categoria
	end
		--Consulta para el comobox con estado=1--
		else if(@TipCons=1)
		begin
			select Cd_Cat+'  |  '+Nombre,Cd_Cat,Nombre from Categoria where Estado=1
		end
			--Consulta general con estado=1--
			else if(@TipCons=2)
			begin
				select Cd_Cat,Nombre,NCorto,Estado from Categoria where Estado=1
			end
				--Consulta para la ayuda con estado=1--
				else if(@TipCons=3)
				begin
					select Cd_Cat,Cd_Cat,Nombre from Categoria where Estado=1
				end

end
print @msj
GO
