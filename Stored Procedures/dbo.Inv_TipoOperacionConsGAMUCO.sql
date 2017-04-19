SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipoOperacionConsGAMUCO]
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
		select Cd_TO,CodSNT_,Nombre from TipoOperacion  where CodSNT_ in ('02','16','17','99') and Estado=1 order by CodSNT_
end
print @msj

-- Leyenda --
-- CAM : 2011-06-30 <Creacion del procedimiento almacenado>
-- El usuario usuica solo debe ver TO = 02,16,99
-- CAM : 2013-02-08 <Modificacion>
-- se agrego el codigo CodSNT_ = 17 para que pueda ver SAlida a CAMpo a pedido del Sr. Guillen por telefono.
GO
