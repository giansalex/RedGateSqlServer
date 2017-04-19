SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraDetProdConsxCt]
@RucE nvarchar(11),
@Cd_Ct char(3),
@TipCons int,
@msj varchar(100) output
as
begin
      --Consulta general--
      if(@TipCons=0)
      begin
            select ctDet.RucE as Ruc,ctDet.Cd_Ct as CodCt,ctDet.Cd_Prod as Codigo,pd.Nombre1 as Nombre,ctDet.Estado, pd.CodCo1_
            from CarteraProdDet_P ctDet
            Left Join CarteraProd ct on ct.RucE=ctDet.RucE and ct.Cd_Ct=ctDet.Cd_Ct
            Left Join Producto2 pd on  pd.RucE=ctDet.RucE and pd.Cd_Prod=ctDet.Cd_Prod
            Where ctDet.RucE=@RucE and ctDet.Cd_Ct=@Cd_Ct and pd.Estado=1 --and ctDet.Estado=1 and ct.Estado=1
      end
end
print @msj
GO
