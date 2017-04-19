SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_ResultadoCons]

@RucE nvarchar(11),
@Cd_Flujo char(10),
@ID_Prc int,
@msj varchar(100) output
as

begin
		select r.RucE, r.Cd_Flujo, r.ID_Prc, r.ID_Rest, r.Cd_Prod, r.ID_UMP, r.Cant, p.CodCo1_, p.Nombre1 as Nombre, u.DescripAlt as Descrip
		from FabResultado as r
		inner join Producto2 as p on r.RucE = p.RucE and r.Cd_Prod = p.Cd_Prod
		inner join Prod_UM as u on r.RucE = u.RucE and r.Cd_Prod = u.Cd_Prod and r.ID_UMP = u.ID_UMP
		where r.RucE = @RucE and r.Cd_Flujo = @Cd_Flujo and r.ID_Prc = @ID_Prc
end
GO
