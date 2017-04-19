SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_ProdUMConsxProd1]
@RucE nvarchar(11),
@Cd_Prod char(7),
@TipCons int,
@msj varchar(100) output
as
--if not exists (select * from Prod_UM where RucE=@RucE and Cd_Prod=@Cd_Prod)
--	set @msj = 'No existe Unidad de Medida para el Producto'+' '+@Cd_Prod
--else	
--begin
if (@TipCons =3)
	begin
		select ID_UMP,Id_UMP,descripAlt+' ('+Nombre+')' as NomUM  from Prod_UM as PUM inner join UnidadMedida as UM on PUM.Cd_UM = UM.Cd_UM and UM.Estado= 1 and Cd_Prod=@Cd_Prod and RucE=@RucE
	end
--end
print @msj
-- Leyenda --
-- FL : 2011-02-04 : <creacion del sp para ayuda del textbox>

GO
