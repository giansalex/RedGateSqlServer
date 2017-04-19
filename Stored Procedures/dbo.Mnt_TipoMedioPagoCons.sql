SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Mnt_TipoMedioPagoCons]
@TipCons int,
@msj varchar(100) output

as
begin
	--Consulta general--
	if(@TipCons=0)
	begin
		select Cd_TMP,'(' + IC_IE + ') ' + Descrip as Descrip,NomCorto,IC_IE,Estado from MedioPago
	end
		--Consulta para el comobox con estado=1--
		else if(@TipCons=1)
		begin
			select Cd_TMP + '  |  '+Descrip,Cd_TMP,Descrip from MedioPago where Estado=1
		end
			--Consulta general con estado=1--
			else if(@TipCons=2)
			begin
				select Cd_TMP,'(' + IC_IE + ') ' + Descrip as Descrip,NomCorto,Estado  from MedioPago where Estado=1
			end
				--Consulta para la ayuda con estado=1--
				else if(@TipCons=3)
				begin
					select Cd_TMP,'(' + IC_IE + ') ' + Descrip as Descrip from MedioPago where Estado=1
				end
end
print @msj
-- LEYENDA
-- cam 23/08/2012 Creacion
GO
