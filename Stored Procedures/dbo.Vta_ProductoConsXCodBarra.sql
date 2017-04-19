SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:   <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Vta_ProductoConsXCodBarra]
@RucE nvarchar(11),
@Cd_Prod char(7),
@CodBarra varchar(30),
@msj varchar(100) output
AS
BEGIN
SET NOCOUNT ON;
      --Select top 1 P.RucE, P.Cd_Prod, P2.Nombre1, P.PVta
      --From Producto2 P2 join Precio P on P2.Cd_Prod = P.Cd_Prod
      --Where P.IB_EsPrin = 1 and P2.CodBarras = @CodBarra
if(ISNULL(@Cd_Prod, '') = '')
    select p.RucE,p.Cd_Prod,p.Nombre1,p.Nombre2,p.Descrip,p.NCorto,p.Cta1,p.Cta2,p.Cta3,p.Cta4,p.Cta5,p.Cta6,p.Cta7,p.Cta8,p.CodCo1_,p.CodCo2_,p.CodCo3_,p.CodBarras,p.FecCaducidad,p.Img,p.StockMin,p.StockMax,p.StockAlerta,p.StockActual,p.StockCot,p.StockSol,p.Cd_TE,p.Cd_Mca,p.Cd_CL,p.Cd_CLS,p.Cd_CLSS,p.Cd_CGP,p.Cd_CC,p.Cd_SC,p.Cd_SS,p.UsuCrea,p.UsuMdf,p.FecReg,p.FecMdf,p.Estado,
	p.IB_PT,p.IB_MP,p.IB_EE,p.IB_Srs, isnull(p.IB_PV,0) as IB_PV, isnull(p.IB_PC,0) as IB_PC, isnull(p.IB_AF,0) as IB_AF,
	pUM.Cd_UM, pUM.ID_UMP, pUM.DescripAlt,
	pr.ValVta, pr.PVta, pr.ID_UMP, pr.Descrip as PrecioDescrip
	from Producto2 p
	inner join Prod_UM pUM on pUM.Cd_Prod = p.Cd_Prod and pUM.RucE = p.RucE
	inner join Precio pr on pr.RucE = p.RucE and pr.Cd_Prod = P.Cd_Prod and pr.ID_UMP = pUM.ID_UMP
	where p.RucE = @RucE and p.CodBarras = @CodBarra  and p.IB_PV = 1
else
	select p.RucE,p.Cd_Prod,p.Nombre1,p.Nombre2,p.Descrip,p.NCorto,p.Cta1,p.Cta2,p.Cta3,p.Cta4,p.Cta5,p.Cta6,p.Cta7,p.Cta8,p.CodCo1_,p.CodCo2_,p.CodCo3_,p.CodBarras,p.FecCaducidad,p.Img,p.StockMin,p.StockMax,p.StockAlerta,p.StockActual,p.StockCot,p.StockSol,p.Cd_TE,p.Cd_Mca,p.Cd_CL,p.Cd_CLS,p.Cd_CLSS,p.Cd_CGP,p.Cd_CC,p.Cd_SC,p.Cd_SS,p.UsuCrea,p.UsuMdf,p.FecReg,p.FecMdf,p.Estado,
	p.IB_PT,p.IB_MP,p.IB_EE,p.IB_Srs, isnull(p.IB_PV,0) as IB_PV, isnull(p.IB_PC,0) as IB_PC, isnull(p.IB_AF,0) as IB_AF,
	pUM.Cd_UM, pUM.ID_UMP, pUM.DescripAlt,
	pr.ValVta, pr.PVta, pr.ID_UMP, pr.Descrip as PrecioDescrip
	from Producto2 p
	inner join Prod_UM pUM on pUM.Cd_Prod = p.Cd_Prod and pUM.RucE = p.RucE
	inner join Precio pr on pr.RucE = p.RucE and pr.Cd_Prod = P.Cd_Prod and pr.ID_UMP = pUM.ID_UMP
	where p.RucE = @RucE and (p.Cd_Prod = @Cd_Prod or p.CodCo1_ = @Cd_Prod) and p.IB_PV = 1

END

--exec Vta_ProductoConsXCodBarra '11111111111', 'PD00007', null, null
--select * from Producto2 where RucE = '11111111111'
--MP : 12/06/2012	<Creacion del procedimiento almacenado>
--MP : 18/06/2012	<Modificacion del procedimiento almacenado>
GO
