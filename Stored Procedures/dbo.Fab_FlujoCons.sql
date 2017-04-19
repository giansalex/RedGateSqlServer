SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_FlujoCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as

begin
	--Consulta general--
	if(@TipCons=0)
		select fab.RucE, fab.Cd_Flujo, fab.Nombre, fab.Descrip, fab.Cd_Prod, fab.ID_UMP,
		 fab.CA01, fab.CA02, fab.CA03, fab.CA04, fab.CA05, fab.CA06, fab.CA07, fab.CA08, fab.CA09, fab.CA10,
		 pro.Nombre1 as NomProducto, ump.DescripAlt as UMP
		from FabFlujo fab
		inner join Producto2 pro on pro.Ruce=fab.ruce and pro.Cd_Prod=fab.Cd_Prod 
		inner join Prod_UM ump on ump.Ruce=fab.ruce and ump.ID_UMP=fab.ID_UMP and ump.Cd_prod=pro.Cd_prod
		where fab.RucE=@RucE
	--Consulta para el comobox con estado=1--
	--else if(@TipCons=1)
	--	select * from FabFlujo where RucE = @RucE
	----Consulta general con estado=1--
	--else if(@TipCons=2)
	--	select *  from FabFlujo where RucE = @RucE
	----Consulta para la ayuda con estado=1--
	--else if(@TipCons=3)
	--	select * from FabFlujo where RucE = @RucE
end
print @msj
GO
