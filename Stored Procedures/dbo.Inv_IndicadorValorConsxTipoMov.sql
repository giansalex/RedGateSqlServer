SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_IndicadorValorConsxTipoMov] --<Procedimiento que consulta indicador valor x Tipo Mov>
@TipCons int,
@Cd_TM char(2),
@msj varchar(100) output
as
begin
	--Consulta para el comobox con estado=1--
	if(@TipCons=1)
	begin
		select Cd_IV+'  |  '+Descrip as CodNom,Cd_IV,Descrip, NomCol
		from IndicadorValor
		Where Cd_TM = @Cd_TM
	end
end
print @msj
------------
--J : 22-04-2010 - <Creacion del procedimiento almacenado>
GO
