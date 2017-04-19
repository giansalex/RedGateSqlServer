SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_ProdUMConsxFrmla]
@RucE nvarchar(11),
@Cd_Prod char(7),
@TipCons int,
@msj varchar(100) output
as
if (@TipCons =3)
begin
	select F.ID_UMP,F.ID_UMP,PUM.descripAlt+' ('+UM.Nombre+')' as NomUM
	from Formula F
	inner join Prod_UM PUM on PUM.RucE=F.RucE and PUM.Cd_Prod=F.Cd_Prod and PUM.ID_UMP=F.ID_UMP
	inner join UnidadMedida UM on UM.Cd_UM=PUM.Cd_UM and UM.Estado=1
	where F.RucE=@RucE and F.Cd_Prod=@Cd_Prod
	group by F.ID_UMP,PUM.descripAlt,UM.Nombre
end
print @msj
-- Leyenda --
-- FL : 2011-02-21 : <creacion del sp para ayuda del textbox de producción>

GO
