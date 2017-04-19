SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MtvoIngSalCons2] --<Procedimiento que consulta los motivos de Ingreso y/o Salida>
@RucE nvarchar(11),
@TipCons int,
@TM char(2),
@msj varchar(100) output
as
--exec Inv_MtvoIngSalCons2 '11111111111','2','',null

begin
	--Consulta general--
	if(@TipCons=0)
	begin
		select mtv.RucE,mtv.Cd_MIS,mtv.Descrip as Descrip,mtv.Cd_TM,tm.NCorto ,mtv.Estado
		from MtvoIngSal mtv
		Left join TipoMov tm on tm.Cd_TM = mtv.Cd_TM
		Where mtv.RucE=@RucE
	end
	--Consulta para el comobox con estado=1--
	else if(@TipCons=1)
	begin
	if(@TM = '')
		begin
		select Cd_MIS+'  |  '+Descrip as CodNom,Cd_MIS,Descrip from MtvoIngSal Where RucE=@RucE and Estado=1
		end
		else
		begin
		select Cd_MIS+'  |  '+Descrip as CodNom,Cd_MIS,Descrip from MtvoIngSal Where RucE=@RucE and Estado=1 and Cd_TM=@TM		
		end
	end

	--Consulta general con estado=1--
	else if(@TipCons=2)
	begin
		select mtv.RucE, mtv.Cd_MIS, mtv.Descrip as Descrip, mtv.Cd_TM, tm.Descrip as DescripTM, mtv.Estado --, '' as TieneAsiento
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
