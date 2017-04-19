SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_Producto2Cons_ProdxPrv1]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output
as

declare @check bit
set @check=0

if(@Cd_Prv is not null)
begin
	select distinct
	0 as Sel,p.Cd_Prod,p.Nombre1 as NomProd,'1' as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
	convert(int,case(c.Cd_ProdB) when p.Cd_Prod then '1' else '0' end) as EsGrupo,p.IB_Srs,
	isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer
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
	0 as Sel,p.Cd_Prod,p.Nombre1 as NomProd, '1' as Cant,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
	convert(int,case(c.Cd_ProdB) when p.Cd_Prod then '1' else '0' end) as EsGrupo,p.IB_Srs,
	isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer
	from  producto2 as p
	left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
	left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
	left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
	left join ProdCombo c on p.RucE=c.RucE and p.Cd_Prod=c.Cd_ProdB 
	where p.RucE=@RucE and p.Estado=1
  end

-- CAM <Fecha de Creacion: 19/01/2011>
--	<Este metodo es identico al Inv_Producto2Cons_paOrdPed pero se agrego la Columna Cantidad para que llene el dataGridView
--	de la pantalla AgregarProducto de Inventario y coloque el valor 1 en Cant. Asi ya no se muestra CERO.>
-- PP  <22/02/2011> Correccion de lo que  no iso carlos
-- FL <26/02/2011> : <se agrego si el producto EsGrupo>
-- FL <09/03/2011> : <se agrego la variable IB_Srs y @Cd_Prv en el where cuando se envia cd_prv>


-- Pruebas:
-- Exec Inv_Producto2Cons_ProdxPrv '11111111111','PRV0253',''
-- Antes el mEtodos Inv_Producto2_ProdxProv de la clase DaoProducto2 usaba el siguiente SP:
-- Exec Inv_Producto2Cons_paOrdPed '11111111111','PRV0004',''
-- Notar que los resultados son los mismos. Solo se muestra una nueva columna.

















GO
