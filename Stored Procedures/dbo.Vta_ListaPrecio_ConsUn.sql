SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_ConsUn] 
    @RucE NVARCHAR(11),
    @Cd_Prod CHAR(7),
    @Id_UMP char(5),
    @Cd_Vta char(10)
AS 



select lp.* from listapreciodet lp
left join ventadet vd on vd.RucE = lp.RucE and vd.Cd_Prod=lp.Cd_Prod and vd.Id_UMP=lp.UMP
left join producto2 p on p.ruce=lp.Ruce and p.Cd_Prod = lp.Cd_Prod
left join prod_UM pu on pu.RucE = lp.RucE and pu.Cd_Prod=lp.Cd_Prod and pu.Id_UMP=lp.UMP
where lp.Ruce = @RucE and lp.Cd_Prod = @Cd_Prod and vd.Id_UMP=@Id_UMP and vd.Cd_Vta=@Cd_Vta

GO
