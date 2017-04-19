SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2Cons_paOrdPed1]
		     
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output

as

declare @check bit
set @check=0

if(@Cd_Prv is not null)
begin
	select distinct
	@check as Sel,p.Cd_Prod,p.Nombre1 as NomProd,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
	isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer

	from Producto2 p 

left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	inner join ProdProv pp on pp.RucE=p.RucE and pp.Cd_Prod = p.Cd_Prod 
	where p.RucE=@RucE and p.Estado=1 and pp.Cd_Prv = @Cd_Prv

end
else
  begin 
	select distinct
	@check as Sel,p.Cd_Prod,p.Nombre1 as NomProd,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer
	from Producto2 p 

left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	--inner join ProdProv pp on pp.RucE=p.RucE and pp.Cd_Prod = p.Cd_Prod 
	where p.RucE=@RucE and p.Estado=1
  end



--PP 2011/02/22 <modifique en el where> no tiene creador






GO
