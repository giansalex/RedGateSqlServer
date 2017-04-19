SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_OrdProdConsProdxFormula]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
--if not exists (select * from Prod_UM where RucE=@RucE and Cd_Prod=@Cd_Prod)
--	set @msj = 'No existe Unidad de Medida para el Producto'+' '+@Cd_Prod
--else	
--begin
if (@TipCons =3)
	begin
		select f.Cd_Prod, isnull(p.CodCo1_,f.Cd_Prod), max(p.Nombre1) as Nombre1 
		from Formula f
		left join producto2 p on p.RucE=f.RucE and p.Cd_Prod=f.Cd_Prod
		where f.RucE=@RucE
		group by f.Cd_Prod, p.CodCo1_
		order by f.Cd_Prod
	end
--end
print @msj
-- Leyenda --
-- FL : 2011-02-19 : <creacion del sp para ayuda del textbox>


GO
