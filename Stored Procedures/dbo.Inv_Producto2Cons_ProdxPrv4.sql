SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_ProdxPrv4]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output
as

declare @check bit
set @check=0

if(@Cd_Prv is not null)
begin
	select distinct
	@check as Sel,p.Cd_Prod,p.Nombre1 as NomProd,'1' as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
	convert(bit,case(c.Cd_ProdB) when p.Cd_Prod then 1 else 0 end) as EsGrupo,
	isnull(p.IB_Srs,0) AS IB_Srs,
	isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer, pp.Cd_Prv,
	p.Cd_CC,p.Cd_SC,p.Cd_SS
	from Producto2 p 
	left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
	left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
	left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	inner join ProdProv pp on pp.RucE=p.RucE and pp.Cd_Prod = p.Cd_Prod
	left join ProdCombo c on p.RucE=c.RucE and p.Cd_Prod=c.Cd_ProdB 
	where p.RucE=@RucE and p.Estado=1 and pp.Cd_Prv=@Cd_Prv
	--group by Cd_Prod, Nombre1, case(Cd_ProdB) when Cd_Prod then '1' else '0' end

end
else
  begin 
	select distinct
	@check as Sel,p.Cd_Prod,p.Nombre1 as NomProd, '1' as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
	convert(bit,case(c.Cd_ProdB) when p.Cd_Prod then 1 else 0 end) as EsGrupo,
	isnull(p.IB_Srs,0) AS IB_Srs,
	isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer, isnull(pp.Cd_Prv,'') as Cd_Prv,
	p.Cd_CC,p.Cd_SC,p.Cd_SS
	from  producto2 as p
	left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
	left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
	left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	left join ProdCombo c on p.RucE=c.RucE and p.Cd_Prod=c.Cd_ProdB 
	left join ProdProv pp on pp.RucE = p.RucE and pp.Cd_Prv = @Cd_Prv and pp.Cd_Prod = p.Cd_Prod
	where p.RucE=@RucE and p.Estado=1
  end
  
 -- LEYENDA
 -- Cam: 20/01/2012 agregue Centro de costos
GO
