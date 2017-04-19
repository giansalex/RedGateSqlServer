SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MarcaCons]
@RucE nvarchar(11),
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
		select RucE, Cd_Mca,Nombre,Descrip,NCorto,Estado, CA01,CA02,CA03 from Marca where RucE = @RucE ORDER BY CONVERT(numeric, Cd_Mca)
	end
		--Consulta para el comobox con estado=1--
		else if(@TipCons=1)
		begin
			select Cd_Mca+'  |  '+Nombre,Cd_Mca,Nombre from Marca where Estado=1 and  RucE = @RucE ORDER BY Cd_Mca
		end
			--Consulta general con estado=1--
			else if(@TipCons=2)
			begin
				select Cd_Mca,Nombre,Descrip,NCorto,Estado, CA01,CA02,CA03  from Marca where Estado=1 and  RucE = @RucE ORDER BY Cd_Mca
			end
				--Consulta para la ayuda con estado=1--
				else if(@TipCons=3)
				begin 
					select Cd_Mca,Cd_Mca,Nombre from Marca where Estado=1 and  RucE = @RucE
				end
end
print @msj
GO
