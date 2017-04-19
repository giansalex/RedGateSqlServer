SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Gsp_MdaCons1]
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
	else 
		select Cd_Mda, Nombre, Simbolo from Moneda where Estado=1

end
print @msj
GO
