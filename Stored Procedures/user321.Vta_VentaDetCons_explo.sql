SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Vta_VentaDetCons_explo]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
	select  vd.Nro_RegVdt, case(isnull(vd.Cd_Prod,'0')) when '0' then vd.Cd_Srv else vd.Cd_Prod end as Cod_Item_,
	vd.Descrip, vd.ID_UMP, um.DescripAlt, 
	case(v.IB_anulado) when 0 then vd.PU else 0 end as PU, 
	case(v.IB_anulado) when 0 then vd.Cant else 0 end as Cant,
	case(v.IB_anulado) when 0 then vd.Valor else 0 end as Valor, 
	case(v.IB_anulado) when 0 then vd.DsctoP else 0 end as DsctoP, 
	case(v.IB_anulado) when 0 then vd.DsctoI else 0 end as DsctoI, 
	case(v.IB_anulado) when 0 then vd.IMP else 0 end as IMP, 
	case(v.IB_anulado) when 0 then vd.IGV else 0 end as IGV, 
	case(v.IB_anulado) when 0 then vd.Total else 0 end as Total,
	vd.Cd_CC, vd.Cd_SC, vd.Cd_SS, vd.Obs, vd.CA01, vd.CA02, vd.CA03, vd.CA04, vd.CA05, vd.CA06, vd.CA07, vd.CA08, vd.CA09, vd.CA10,
	vd.Cd_Alm, alm.Nombre as Almacen, iv.Descrip as IndicadorAfectoVta,
	v.IB_anulado as IB_anulado
	from ventadet vd
	left join Prod_UM um on vd.RucE=um.RucE and vd.ID_UMP=um.ID_UMP and vd.Cd_Prod=um.Cd_Prod
	left join Almacen alm on Alm.Cd_Alm=vd.Cd_Alm and alm.RucE=vd.RucE
	left join IndicadorAfectoVta iv on iv.Cd_IAV=vd.Cd_IAV
	left join venta v on vd.cd_vta = v.cd_vta and vd.RucE = v.RucE
	where vd.ruce=@RucE and vd.Cd_Vta=@Cd_Vta --and Cd_Pro_NO is null

-- Leyenda --
-- JJ	2010-09-22:	<Creacion del Procedimiento Almacenado>
-- MM	2011-07-15: <Modificacion - Se agrego la validacion para venta anulada>

--exec user321.Vta_VentaDetCons_explo '11111111111', 'VT00000657', null
GO
