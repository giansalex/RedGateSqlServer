SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_AsientoCons] --<Procedimiento que consulta los asientos>
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
	--Consulta general--
	if(@TipCons=0)
	begin
		select a.RucE,a.Cd_MIS,mtv.Descrip as DescripMTV,a.Item,a.Cta,a.IC_CaAb,a.Cd_IV,iv.Descrip as DescripIV,a.Porc
		from Asiento a
		Left join MtvoIngSal mtv on mtv.RucE=a.RucE and mtv.Cd_MIS=a.Cd_MIS
		Left join IndicadorValor iv on iv.Cd_IV=a.Cd_IV
		Where a.RucE=@RucE
	end
	--Consulta para el comobox con estado=1--
	/*FALTA*/

	--Consulta general con estado=1--
	else if(@TipCons=2)
	begin
		select a.RucE,a.Cd_MIS,mtv.Descrip as DescripMTV,a.Item,a.Cta,a.IC_CaAb,a.Cd_IV,iv.Descrip as DescripIV,a.Porc
		from Asiento a
		Left join MtvoIngSal mtv on mtv.RucE=a.RucE and mtv.Cd_MIS=a.Cd_MIS
		Left join IndicadorValor iv on iv.Cd_IV=a.Cd_IV
		Where a.RucE=@RucE and mtv.Estado=1
	end
	--Consulta para la ayuda con estado=1--
	--else if(@TipCons=3)
	/*FALTA*/
end
print @msj
------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>
GO
