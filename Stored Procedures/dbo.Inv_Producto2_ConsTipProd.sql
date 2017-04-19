SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2_ConsTipProd]
@RucE nvarchar(11),
@TipProd int,
@msj varchar(100) output
as

begin 
if(@TipProd =0)
	select distinct
	0 as Sel,p.Cd_Prod,p.Nombre1 as NomProd, '1' as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase
	from  producto2 as p
	left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
	left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
	left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	where p.RucE=@RucE and p.Estado=1 and p.IB_PT=1
else if(@TipProd =1)
	select distinct
	0 as Sel,p.Cd_Prod,p.Nombre1 as NomProd, '1' as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase
	from  producto2 as p
	left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
	left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
	left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	where p.RucE=@RucE and p.Estado=1 and p.IB_MP=1
else
	select distinct
	0 as Sel,p.Cd_Prod,p.Nombre1 as NomProd, '1' as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase
	from  producto2 as p
	left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
	left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
	left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	where p.RucE=@RucE and p.Estado=1 and p.IB_EE=1
  end

-- FL <27/02/2011> : <crea creo el procedimiento almacenado>
-- PP <27/02/2011> : <modifico el procedimiento almacenado>

-- Pruebas:
-- Exec Inv_Producto2_ConsEE '11111111111',''




GO
