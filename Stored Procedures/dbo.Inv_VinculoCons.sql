SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_VinculoCons]--Consulta de datos de vinculos para Persona referencia
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
	--Consulta general--
	if(@TipCons=0)
	begin
		select * from Vinculo
	end
		--Consulta para el comobox con estado=1--
		else if(@TipCons=1)
		begin
			select Cd_Vin+'  |  '+Descrip,Cd_Vin,Descrip from Vinculo where RucE=@RucE and Estado=1
		end
			--Consulta general con estado=1--
			else if(@TipCons=2)
			begin
				select * from Vinculo where RucE=@RucE and Estado=1
			end
				--Consulta para la ayuda con estado=1--
				else if(@TipCons=3)
				begin
					select Cd_Vin,Cd_Vin,Descrip from Vinculo where RucE=@RucE and Estado=1
				end

end
print @msj
GO
