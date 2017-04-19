SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_MdaCons]
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from Moneda)
	set @msj = 'No se encontro Moneda'

else */
begin
	if(@TipCons=0)
	   select * from Moneda
--	else select  Cd_Mda, Simbolo from Moneda where Estado=1
	else select Cd_Mda+'  |  '+Nombre as CodNom, Cd_Mda, Simbolo, Nombre from Moneda where Estado=1

end
print @msj
GO
