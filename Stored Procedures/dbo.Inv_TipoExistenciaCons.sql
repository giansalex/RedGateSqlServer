SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipoExistenciaCons]
@TipCons int,
@msj varchar(100) output
as
begin
	--Consulta general--
	if(@TipCons=0)
	begin
		select * from TipoExistencia
	end
	--Consulta para el comobox con estado=1--
	else if(@TipCons=1)
	begin
		select * from TipoExistencia
		select Cd_TE+'  |  '+Nombre as CdTipExist,Cd_TE,Nombre from TipoExistencia where Estado=1
	end
	--Consulta general con estado=1--
	else if(@TipCons=2)
	begin
		select Cd_TE,CodSNT_,Nombre,NCorto,Estado from TipoExistencia where Estado=1
	end
	--Consulta para la ayuda con estado=1--
	else if(@TipCons=3)
	begin
		select Cd_TE,Cd_TE,Nombre from TipoExistencia where Estado=1
	end
end
print @msj
GO
