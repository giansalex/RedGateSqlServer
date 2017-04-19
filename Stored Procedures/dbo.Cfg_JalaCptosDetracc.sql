SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Cfg_JalaCptosDetracc]
@RucE nvarchar(11),
@RucEBase nvarchar(11)
as

insert into Producto2(RucE,Cd_Prod,Nombre1,Nombre2,Descrip,NCorto,Cta1,Cta2,CodCo1_,CodCo2_,CodCo3_,
					  CodBarras,FecCaducidad,Img,StockMin,StockMax,StockAlerta,StockActual,StockCot,
					  StockSol,Cd_TE,Cd_Mca,Cd_CL,Cd_CLS,Cd_CLSS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,UsuCrea,
					  UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,
					  IB_PT,IB_MP,IB_EE,IB_Srs,IB_PV,IB_PC,IB_AF)
select @RucE,Cd_Prod,Nombre1,Nombre2,Descrip,NCorto,Cta1,Cta2,CodCo1_,CodCo2_,CodCo3_,
					  CodBarras,FecCaducidad,Img,StockMin,StockMax,StockAlerta,StockActual,StockCot,
					  StockSol,Cd_TE,Cd_Mca,Cd_CL,Cd_CLS,Cd_CLSS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,UsuCrea,
					  UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,
					  IB_PT,IB_MP,IB_EE,IB_Srs,IB_PV,IB_PC,IB_AF 
from Producto2 where RucE=@RucEBase


insert into Servicio2(RucE,Cd_Srv,CodCo,Nombre,Descrip,NCorto,Cta1,Cta2,Img,Cd_GS,Cd_CGP,Cd_CC,Cd_SC,
					  Cd_SS,IC_TipServ,UsuCrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,
					  CA06,CA07,CA08,CA09,CA10)
select @RucE,Cd_Srv,CodCo,Nombre,Descrip,NCorto,Cta1,Cta2,Img,Cd_GS,Cd_CGP,Cd_CC,Cd_SC,
					  Cd_SS,IC_TipServ,UsuCrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,
					  CA06,CA07,CA08,CA09,CA10
from Servicio2 where RucE=@RucEBase

insert into ConceptosDetrac (RucE,Cd_CDtr,Descrip,Cd_Prod,Cd_Srv)
select @RucE,Cd_CDtr,Descrip,Cd_Prod,Cd_Srv 
from   ConceptosDetrac where RucE=@RucEBase

insert into ConceptoDetracHist (RucE,Cd_CDtr,FecVig,Porc,MtoDtr)
select @RucE,Cd_CDtr,FecVig,Porc,MtoDtr 
from ConceptoDetracHist where RucE=@RucEBase



GO
