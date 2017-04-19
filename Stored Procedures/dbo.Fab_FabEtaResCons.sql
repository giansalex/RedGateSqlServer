SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_FabEtaResCons]

@RucE nvarchar(11),
@Cd_Fab char(10),
@ID_Eta int,
@msj varchar(100) output
as

begin
		select i.RucE, i.Cd_Fab, i.ID_Eta, i.ID_EtaRes, i.Cd_Flujo, i.ID_Prc, i.ID_Res, i.Fec,i.Cd_Prod, i.ID_UMP, i.Cant, i.Costo, i.Costo_ME, p.CodCo1_, p.Nombre1 as Nombre, u.DescripAlt as Descrip
		from FabEtaRes as i 
		inner join Producto2 as p on i.RucE = p.RucE and i.Cd_Prod = p.Cd_Prod
		inner join Prod_UM as u on i.RucE = u.RucE and i.Cd_Prod = u.Cd_Prod and i.ID_UMP = u.ID_UMP
		where i.RucE = @RucE and i.Cd_Fab = @Cd_Fab and i.ID_Eta = @ID_Eta
end
print @msj

GO
