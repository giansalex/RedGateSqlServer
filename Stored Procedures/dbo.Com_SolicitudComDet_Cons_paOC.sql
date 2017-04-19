SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_SolicitudComDet_Cons_paOC]
@RucE nvarchar(11),
@Cd_SC char(10),
@msj varchar(100) output
as

select sc.Item, sc.Cd_Prod, pr.Nombre1 as Descrip ,pu.DescripAlt as UM,sc.ID_UMP,isnull(sc.Cant,0) as Cant from SolicitudComDet sc 
inner join Producto2 pr on sc.RucE = pr.RucE and sc.Cd_Prod = pr.Cd_Prod
inner join Prod_UM pu on sc.RucE = pu.RucE and sc.Cd_Prod = pu.Cd_Prod and sc.ID_UMP = pu.ID_UMP
where  sc.RucE = @RucE and sc.Cd_SC = @Cd_SC
print @msj
GO
