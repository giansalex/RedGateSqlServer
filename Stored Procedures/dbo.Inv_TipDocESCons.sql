SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipDocESCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
	--Consulta general--
	if(@TipCons=0)
		select * from TipDocES where RucE=@RucE
	--Consulta para el comobox con estado=1--
	else if(@TipCons=1)
		select Cd_TDES+'  |  '+Nombre as CodNom,Cd_TDES,Nombre from TipDocES Where RucE=@RucE and Estado=1
	--Consulta general con estado=1--
	else if(@TipCons=2)
		select * from TipDocES where Estado = 1
	--Consulta para la ayuda con estado=1--
	else if(@TipCons=3)
		select Cd_TDES,Cd_TDES,Nombre from TipDocES Where RucE=@RucE and Estado=1
end
print @msj
------------
--PP : 2010-06-09 13:28:24.717 - <Creacion del procedimiento almacenado>
GO
