SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipoOperacionCons]
@TipCons int,
@msj varchar(100) output
as
begin
	--Consulta general--
	if(@TipCons=0)
		select * from TipoOperacion
	--Consulta para el comobox con estado=1--
	else if(@TipCons=1)
		select CodSNT_+'  |  '+Nombre,CodSNT_,Nombre from TipoOperacion where Estado=1
	--Consulta general con estado=1--
	else if(@TipCons=2)
		select  * from TipoOperacion where Estado=1
	--Consulta para la ayuda con estado=1--
	else if(@TipCons=3)
		select Cd_TO,CodSNT_,Nombre from TipoOperacion where Estado=1
end
print @msj

-- Leyenda --
-- PP : 2010-03-29 14:01:25.153: <Creacion del procedimiento almacenado>
GO
