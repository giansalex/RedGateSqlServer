SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Gsp_EntidadFinancieraCons]
@TipCons int,
@msj varchar(100) output
as
set @msj=''
	if(@TipCons=1)
		select CodSNT_ + ' | ' + Nombre as CodNom,Cd_EF,Nombre  from EntidadFinanciera where Estado=1
	else if(@TipCons=3)
		select Cd_EF,CodSNT_,Nombre from EntidadFinanciera where Estado=1
-- Leyenda --
--JJ 18/02/2011	<Creacion del Procedimiento Almacenado>
GO
