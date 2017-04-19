SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImportacionDetCons] 
@RucE nvarchar(11),
@Cd_IP char(7),
@msj varchar(100) output
as
	select i.RucE,i.Cd_IP,i.Item,i.Cd_Prod,i.ID_UMP,i.Cd_Com,c.RegCtb,i.ItemCP,i.Cant,i.PesoKg,i.Volumen,
	i.EXW,i.Com,i.OtroE,i.FOB,i.Flete,i.Seg,i.OtroF,i.CIF,i.Adv,i.OtroC,i.Total,i.CU,i.Ratio,
	i.EXW_ME,i.Com_ME,i.OtroE_ME,i.FOB_ME,i.Flete_ME,i.Seg_ME,i.OtroF_ME,i.CIF_ME,i.Adv_ME,i.OtroC_ME,i.Total_ME,i.CU_ME,i.Ratio_ME,
	p.Nombre1 as 'ProdNom',
	p.Descrip as 'ProdDescrip',
	um.Nombre as 'UMPNom',
	pum.DescripAlt as 'UMPDescrip',
	c.NroSre as 'NroSre',
	c.NroDoc as 'NroDoc',
	case c.Cd_Mda when '01' then d.IMP else d.IMP*c.CamMda end as 'CUC',
	case c.Cd_Mda when '02' then d.IMP else d.IMP/c.CamMda end as 'CUC_ME',
	d.cant - ABS(isnull((select sum(ii.Cant) from ImportacionDet ii left join CompraDet as id 
		on id.RucE =ii.RucE and id.Cd_Com = ii.Cd_Com and id.Item = ii.ItemCP
		where ii.RucE = @RucE and ii.Cd_Com = d.Cd_Com and ii.Cd_IP <> @Cd_IP and ii.ItemCP = d.Item),0 )) as 'Max'
	from importacionDet as i
	inner join Producto2 as p on i.RucE = p.RucE and i.Cd_Prod = p.Cd_Prod
	inner join Prod_UM as pum on i.RucE = pum.RucE and i.Cd_Prod = pum.Cd_Prod and i.ID_UMP = pum.ID_UMP
	inner join UnidadMedida as um on pum.Cd_UM = um.Cd_UM
	inner join Compra as c on c.RucE = i.RucE and c.Cd_Com = i.Cd_Com
	inner join CompraDet as d on d.RucE = i.RucE and d.Cd_Com = i.Cd_Com and d.Item = i.ItemCP
	where i.RucE=@RucE and i.Cd_IP=@Cd_IP
	
--exec Imp_ImportacionDetCons '11111111111','IP00050',null



GO
