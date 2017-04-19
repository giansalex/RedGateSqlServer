SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--select *from producto2 where Cd_Prod='PD00007'
--exec [user321].[Vta_VentaDetCons_explo1] '11111111111','VT00001025',null
CREATE proc [user321].[Vta_VentaDetCons_explo1]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
	select  vd.Nro_RegVdt, case(isnull(vd.Cd_Prod,'0')) when '0' then vd.Cd_Srv else vd.Cd_Prod end as Cod_Item_,
	Case when isnull(vd.Cd_Srv,'') ='' then p2.CodCo1_ else s2.CodCo end as CodCo1_,
	--p2.CodCo1_,
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
	v.IB_anulado as IB_anulado,
	vd.UsuMdfCostoPrm, v.Cd_Mda,
	case when (v.Cd_Mda = '01') then vd.CU else vd.CU_ME end as CU,
	case when (v.Cd_Mda = '01') then vd.Costo else vd.Costo_ME end as Costo
	from ventadet vd
	left join Prod_UM um on vd.RucE=um.RucE and vd.ID_UMP=um.ID_UMP and vd.Cd_Prod=um.Cd_Prod
	left join producto2 p2 on p2.RucE=vd.RucE and p2.Cd_Prod=vd.Cd_Prod
	left join Servicio2 s2 on s2.RucE=vd.RucE and s2.Cd_Srv=vd.Cd_Srv
	left join Almacen alm on Alm.Cd_Alm=vd.Cd_Alm and alm.RucE=vd.RucE
	left join IndicadorAfectoVta iv on iv.Cd_IAV=vd.Cd_IAV
	left join venta v on vd.cd_vta = v.cd_vta and vd.RucE = v.RucE
	where vd.ruce=@RucE and vd.Cd_Vta=@Cd_Vta --and Cd_Pro_NO is null

-- Leyenda --
--CAM 25/05/2012 creacion Servicio2
--CES 07/08/2012 modificacion -> Costo/Costo_ME
--exec user321.Vta_VentaDetCons_explo1 '11111111111', 'VT00001013', null

GO
