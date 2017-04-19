SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MtvoIngSalCons] --<Procedimiento que consulta los motivos de Ingreso y/o Salida>
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output,
@Ejer nvarchar(4) --GC2016 PV: Agregado el 23/04/2016
as
--exec Inv_MtvoIngSalCons '11111111111','0',null,2010

begin
	--Consulta general--
	if(@TipCons=0)
	begin
		/*GC2016 PV: comentado el 23/04/2016
		select mtv.RucE,mtv.Cd_MIS,mtv.Descrip as Descrip,mtv.Cd_TM,tm.NCorto ,mtv.Estado
		from MtvoIngSal mtv
		Left join TipoMov tm on tm.Cd_TM = mtv.Cd_TM
		Where mtv.RucE=@RucE
		*/

		--GC2016 PV: Agregado el 23/04/2016
		select mtv.RucE,mtv.Cd_MIS,mtv.Descrip as Descrip,mtv.Cd_TM,tm.Descrip as DescripTM,mtv.Estado,  case(isnull(len(T2.RucE),0)) when 0 then '-' else 'SI' end as TieneAsiento
		from MtvoIngSal mtv
		Left join TipoMov tm on tm.Cd_TM = mtv.Cd_TM
		Left join (select Distinct RucE, Ejer, Cd_MIS from Asiento) T2
		on mtv.RucE=T2.RucE and mtv.Cd_MIS=T2.Cd_MIS and T2.Ejer=@Ejer
		Where mtv.RucE=@RucE 

	end
	--Consulta para el comobox con estado=1--
	else if(@TipCons=1)
	begin
		select Cd_MIS+'  |  '+Descrip as CodNom,Cd_MIS,Descrip from MtvoIngSal Where RucE=@RucE and Estado=1
	end

	--Consulta general con estado=1--
	else if(@TipCons=2)
	begin
		select mtv.RucE,mtv.Cd_MIS,mtv.Descrip as Descrip,mtv.Cd_TM,tm.Descrip as DescripTM,mtv.Estado
		from MtvoIngSal mtv
		Left join TipoMov tm on tm.Cd_TM = mtv.Cd_TM
		Where mtv.RucE=@RucE and mtv.Estado=1
	end

	--Consulta para la ayuda con estado=1--
	else if(@TipCons=3)
	begin
		select Cd_MIS,Cd_MIS,Descrip from MtvoIngSal Where RucE=@RucE and Estado=1
	end
end
print @msj
------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>
GO
