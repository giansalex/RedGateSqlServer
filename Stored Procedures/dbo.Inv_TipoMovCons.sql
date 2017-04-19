SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_TipoMovCons] --<Procedimiento que consulta los tipos de movimientos>
@TipCons int,
@msj varchar(100) output
as
begin
	--Consulta para el comobox con estado=1--
	if(@TipCons=1)
	begin
		select Cd_TM+'  |  '+Descrip as CodNom,Cd_TM,Descrip from TipoMov
	end
end
print @msj
------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>
GO
