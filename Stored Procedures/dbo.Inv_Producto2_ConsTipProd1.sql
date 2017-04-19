SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2_ConsTipProd1]
@RucE nvarchar(11),
@TipProd int,
@msj varchar(100) output
as

begin 
if(@TipProd =0)
	select distinct
	convert(bit, 0) as Sel,p.Cd_Prod,p.Nombre1 as NomProd, '1' as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
	isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer,
	CCo.Cd_CC , SCCo.Cd_SC, SSCCo.Cd_SS
	from  producto2 as p
	left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
	left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
	left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	left join CCostos CCo on CCo.RucE = p.RucE and CCo.Cd_CC = p.Cd_CC
	left join CCSub SCCo on SCCo.RucE = p.RucE and SCCo.Cd_SC = p.Cd_SC and SCCO.Cd_CC = p.Cd_CC
	left join CCSubSub SSCCo on SSCCo.RucE = p.RucE and SSCCO.Cd_SS = p.Cd_SS and SSCCO.Cd_SC = p.Cd_SC and SSCCo.Cd_CC = p.Cd_CC	
	
	where p.RucE=@RucE and p.Estado=1 and p.IB_PT=1
else if(@TipProd =1)
	select distinct
	convert(bit, 0) as Sel,p.Cd_Prod,p.Nombre1 as NomProd, '1' as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
	isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer,
	CCo.Cd_CC , SCCo.Cd_SC, SSCCo.Cd_SS
	from  producto2 as p
	left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
	left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
	left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	left join CCostos CCo on CCo.RucE = p.RucE and CCo.Cd_CC = p.Cd_CC
	left join CCSub SCCo on SCCo.RucE = p.RucE and SCCo.Cd_SC = p.Cd_SC and SCCO.Cd_CC = p.Cd_CC
	left join CCSubSub SSCCo on SSCCo.RucE = p.RucE and SSCCO.Cd_SS = p.Cd_SS and SSCCO.Cd_SC = p.Cd_SC and SSCCo.Cd_CC = p.Cd_CC	
	
	where p.RucE=@RucE and p.Estado=1 and p.IB_MP=1
else
	select distinct
	convert(bit, 0) as Sel,p.Cd_Prod,p.Nombre1 as NomProd, '1' as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
	isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer,
	CCo.Cd_CC , SCCo.Cd_SC, SSCCo.Cd_SS
	from  producto2 as p
	left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
	left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
	left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	left join CCostos CCo on CCo.RucE = p.RucE and CCo.Cd_CC = p.Cd_CC
	left join CCSub SCCo on SCCo.RucE = p.RucE and SCCo.Cd_SC = p.Cd_SC and SCCO.Cd_CC = p.Cd_CC
	left join CCSubSub SSCCo on SSCCo.RucE = p.RucE and SSCCO.Cd_SS = p.Cd_SS and SSCCO.Cd_SC = p.Cd_SC and SSCCo.Cd_CC = p.Cd_CC	
	
	where p.RucE=@RucE and p.Estado=1 and p.IB_EE=1
  end

-- FL <27/02/2011> : <crea creo el procedimiento almacenado>
-- PP <27/02/2011> : <modifico el procedimiento almacenado>
GO
