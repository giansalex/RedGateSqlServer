SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_LineaCons]
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
		select Cd_Ln,Nombre,NCorto,Estado from Linea
	end
		--Consulta para el comobox con estado=1--
		else if(@TipCons=1)
		begin
			select Cd_Ln+'  |  '+Nombre,Cd_Ln,Nombre from Linea where Estado=1
		end
			--Consulta general con estado=1--
			else if(@TipCons=2)
			begin
				select Cd_Ln,Nombre,NCorto,Estado from Linea where Estado=1
			end
				--Consulta para la ayuda con estado=1--
				else if(@TipCons=3)
				begin
					select Cd_Ln,Cd_Ln,Nombre from Linea where Estado=1
				end
end
print @msj
GO
