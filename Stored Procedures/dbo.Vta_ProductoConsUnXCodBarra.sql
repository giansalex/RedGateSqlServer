SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:   <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Vta_ProductoConsUnXCodBarra]
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
    select top 1 p.RucE,p.Cd_Prod,p.Nombre1,p.Nombre2,p.Descrip,p.NCorto,p.Cta1,p.Cta2,p.Cta3,p.Cta4,p.Cta5,p.Cta6,p.Cta7,p.Cta8,p.CodCo1_,p.CodCo2_,p.CodCo3_,p.CodBarras,p.FecCaducidad,p.Img,p.StockMin,p.StockMax,p.StockAlerta,p.StockActual,p.StockCot,p.StockSol,p.Cd_TE,p.Cd_Mca,p.Cd_CL,p.Cd_CLS,p.Cd_CLSS,p.Cd_CGP,p.Cd_CC,p.Cd_SC,p.Cd_SS,p.UsuCrea,p.UsuMdf,p.FecReg,p.FecMdf,p.Estado,p.CA01,p.CA02,p.CA03,p.CA04,p.CA05,p.CA06,p.CA07,p.CA08,p.CA09,p.CA10,
	te.Nombre as TEnombre,mar.Nombre as MARnombre,cl.Nombre as CLnombre,scl.Nombre as SCLnombre,sscl.Nombre as SSCLnombre,cc.Descrip as CCdescrip,ccs.Descrip as CCSdescrip,ccss.Descrip as CCSSdescrip,
	p.IB_PT,p.IB_MP,p.IB_EE,p.IB_Srs, isnull(p.IB_PV,0) as IB_PV, isnull(p.IB_PC,0) as IB_PC, isnull(p.IB_AF,0) as IB_AF,
	pr.ValVta, pr.PVta, pr.ID_UMP
	from Producto2 p
	left join TipoExistencia te on te.Cd_TE=p.Cd_TE
	left join Marca mar on mar.Cd_Mca=p.Cd_Mca and mar.RucE=p.RucE
	
	left join Clase cl On cl.RucE=p.RucE and cl.Cd_CL=p.Cd_CL
	left join ClaseSub scl On scl.RucE=p.RucE and scl.Cd_CLS=p.Cd_CLS and scl.Cd_CL=p.Cd_CL
	left join ClaseSubSub sscl On sscl.RucE=p.RucE and sscl.Cd_CLSS=p.Cd_CLSS and sscl.Cd_CLS=p.Cd_CLS and sscl.Cd_CL=p.Cd_CL
	
	left join CCostos cc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC
	left join CCSub ccs on ccs.RucE=p.RucE and ccs.Cd_CC=p.Cd_CC and ccs.Cd_SC=p.Cd_SC
	left join CCSubSub ccss on ccss.RucE=p.RucE and ccss.Cd_CC=p.Cd_CC and ccss.Cd_SC=p.Cd_SC and ccss.Cd_SS=p.Cd_SS
	
	left join Precio pr on pr.Cd_Prod = P.Cd_Prod
	where p.RucE = @RucE and p.CodBarras = @CodBarra
else
	select top 1 p.RucE,p.Cd_Prod,p.Nombre1,p.Nombre2,p.Descrip,p.NCorto,p.Cta1,p.Cta2,p.Cta3,p.Cta4,p.Cta5,p.Cta6,p.Cta7,p.Cta8,p.CodCo1_,p.CodCo2_,p.CodCo3_,p.CodBarras,p.FecCaducidad,p.Img,p.StockMin,p.StockMax,p.StockAlerta,p.StockActual,p.StockCot,p.StockSol,p.Cd_TE,p.Cd_Mca,p.Cd_CL,p.Cd_CLS,p.Cd_CLSS,p.Cd_CGP,p.Cd_CC,p.Cd_SC,p.Cd_SS,p.UsuCrea,p.UsuMdf,p.FecReg,p.FecMdf,p.Estado,p.CA01,p.CA02,p.CA03,p.CA04,p.CA05,p.CA06,p.CA07,p.CA08,p.CA09,p.CA10,
	te.Nombre as TEnombre,mar.Nombre as MARnombre,cl.Nombre as CLnombre,scl.Nombre as SCLnombre,sscl.Nombre as SSCLnombre,cc.Descrip as CCdescrip,ccs.Descrip as CCSdescrip,ccss.Descrip as CCSSdescrip,
	p.IB_PT,p.IB_MP,p.IB_EE,p.IB_Srs, isnull(p.IB_PV,0) as IB_PV, isnull(p.IB_PC,0) as IB_PC, isnull(p.IB_AF,0) as IB_AF,
	pr.ValVta, pr.PVta, pr.ID_UMP
	from Producto2 p
	left join TipoExistencia te on te.Cd_TE=p.Cd_TE
	left join Marca mar on mar.Cd_Mca=p.Cd_Mca and mar.RucE=p.RucE
	
	left join Clase cl On cl.RucE=p.RucE and cl.Cd_CL=p.Cd_CL
	left join ClaseSub scl On scl.RucE=p.RucE and scl.Cd_CLS=p.Cd_CLS and scl.Cd_CL=p.Cd_CL
	left join ClaseSubSub sscl On sscl.RucE=p.RucE and sscl.Cd_CLSS=p.Cd_CLSS and sscl.Cd_CLS=p.Cd_CLS and sscl.Cd_CL=p.Cd_CL
	
	left join CCostos cc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC
	left join CCSub ccs on ccs.RucE=p.RucE and ccs.Cd_CC=p.Cd_CC and ccs.Cd_SC=p.Cd_SC
	left join CCSubSub ccss on ccss.RucE=p.RucE and ccss.Cd_CC=p.Cd_CC and ccss.Cd_SC=p.Cd_SC and ccss.Cd_SS=p.Cd_SS
	
	left join Precio pr on pr.Cd_Prod = P.Cd_Prod
	where p.RucE = @RucE and p.Cd_Prod = @Cd_Prod

END
GO
