SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2ConsUn1]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output,
@Grupo bit output
as

if not exists (select * from Producto2 where Cd_Prod=@Cd_Prod and RucE = @RucE)
	set @msj = 'Producto no existe'
else
begin
	select p.RucE,p.Cd_Prod,p.Nombre1,p.Nombre2,p.Descrip,p.NCorto,p.Cta1,p.Cta2,p.CodCo1_,p.CodCo2_,p.CodCo3_,p.CodBarras,p.FecCaducidad,p.Img,p.StockMin,p.StockMax,p.StockAlerta,p.StockActual,p.StockCot,p.StockSol,p.Cd_TE,p.Cd_Mca,p.Cd_CL,p.Cd_CLS,p.Cd_CLSS,p.Cd_CGP,p.Cd_CC,p.Cd_SC,p.Cd_SS,p.UsuCrea,p.UsuMdf,p.FecReg,p.FecMdf,p.Estado,p.CA01,p.CA02,p.CA03,p.CA04,p.CA05,p.CA06,p.CA07,p.CA08,p.CA09,p.CA10,
	te.Nombre as TEnombre,mar.Nombre as MARnombre,cl.Nombre as CLnombre,scl.Nombre as SCLnombre,sscl.Nombre as SSCLnombre,cc.Descrip as CCdescrip,ccs.Descrip as CCSdescrip,ccss.Descrip as CCSSdescrip  from Producto2 p
	left join TipoExistencia te on te.Cd_TE=p.Cd_TE
	left join Marca mar on mar.Cd_Mca=p.Cd_Mca and mar.RucE=p.RucE
	--left join Clase cl on cl.Cd_CL=prod.Cd_CL and cl.RucE=prod.RucE
	--left join ClaseSub scl on scl.RucE=prod.RucE and scl.Cd_CL=prod.Cd_CL and scl.Cd_CLS=prod.Cd_CLS
	--left join ClaseSubSub sscl on sscl.RucE=prod.RucE and sscl.Cd_CL=prod.Cd_CL and sscl.Cd_CLS=prod.Cd_CLS and sscl.Cd_CLSS=prod.Cd_CLSS
	
	left join Clase cl On cl.RucE=p.RucE and cl.Cd_CL=p.Cd_CL
	left join ClaseSub scl On scl.RucE=p.RucE and scl.Cd_CLS=p.Cd_CLS and scl.Cd_CL=p.Cd_CL
	left join ClaseSubSub sscl On sscl.RucE=p.RucE and sscl.Cd_CLSS=p.Cd_CLSS and sscl.Cd_CLS=p.Cd_CLS and sscl.Cd_CL=p.Cd_CL
	
	left join CCostos cc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC
	left join CCSub ccs on ccs.RucE=p.RucE and ccs.Cd_CC=p.Cd_CC and ccs.Cd_SC=p.Cd_SC
	left join CCSubSub ccss on ccss.RucE=p.RucE and ccss.Cd_CC=p.Cd_CC and ccss.Cd_SC=p.Cd_SC and ccss.Cd_SS=p.Cd_SS
	where p.Cd_Prod=@Cd_Prod and p.RucE = @RucE
	set @Grupo  = (select Case(Count(Cd_ProdB)) when 0 then 0 else 1 end from ProdCombo where RucE = @RucE and Cd_ProdB=@Cd_Prod)
end
print @msj

-- Leyenda --
-- PP : 2010-02-23 : <Creacion del procedimiento almacenado>
-- FL : 2010-09-13 : <Se agregaron las descrips y nombres>




GO
