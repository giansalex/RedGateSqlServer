SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_IndicadorValorCons] --<Procedimiento que consulta indicador valor>
@TipCons int,
@msj varchar(100) output
as
begin
	--Consulta para el comobox con estado=1--
	if(@TipCons=1)
	begin
		select Cd_IV+'  |  '+Descrip as CodNom,Cd_IV,Descrip from IndicadorValor
	end
end
print @msj
------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>
GO
