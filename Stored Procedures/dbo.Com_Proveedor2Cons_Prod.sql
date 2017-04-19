SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2Cons_Prod]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output
as
select 
	pp.RucE,pd.Cd_Prod,pd.Nombre1,pd.NCorto--,pd.Img
	from ProdProv pp
	Left join Producto2 pd on pd.RucE = pp.RucE and pd.Cd_Prod = pp.Cd_Prod
	Left join Proveedor2 prv on prv.RucE = pp.RucE and prv.Cd_Prv = pp.Cd_Prv
	Where pp.RucE=@RucE and pp.Cd_Prv=@Cd_Prv
	group by pp.RucE,pd.Cd_Prod,pd.Nombre1,pd.NCorto--,pd.Img
print @msj
--J -<Creado 06/09/2010>
-- ejemplo --
-- exec Com_Proveedor2Cons_Prod '11111111111','PRV0001',null

GO
