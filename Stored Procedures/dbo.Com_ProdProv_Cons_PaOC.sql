SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_ProdProv_Cons_PaOC]
@RucE nvarchar(11),
@Cd_SC char(10),
@Cd_Prv char(7),
@msj varchar(100) output
as

select distinct pp.CD_Prod, pr.Nombre1 as Descrip ,pu.DescripAlt as UM , pp.ID_UMP from ProdProv pp
inner join Producto2 pr on pp.RucE = pr.RucE and pp.Cd_Prod = pr.Cd_Prod 
inner join Prod_UM pu on pp.RucE = pu.RucE and pp.Cd_Prod = pu.Cd_Prod and pp.ID_UMP = pu.ID_UMP
inner join SolicitudComDet sc on pp.RucE = sc.RucE and pp.Cd_Prod = sc.Cd_Prod and pp.ID_UMP = sc.ID_UMP
where pp.RucE = @RucE and pp.Cd_Prv = @Cd_Prv and sc.Cd_SC = @Cd_SC
print @msj


GO
