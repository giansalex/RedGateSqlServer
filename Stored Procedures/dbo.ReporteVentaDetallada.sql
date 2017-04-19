SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ReporteVentaDetallada]


@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
--@Prdo char(2),
@vendedor char(7),
@Area varchar(50),
@FecIni datetime,--nvarchar(10),
@FecFin datetime,   --nvarchar(10)
@msj varchar(100) output,
@Cd_Clt char(10)
as
---------CABECERA-----------------------------------------------
select 
	v.Prdo,(v.NroSre+'-'+v.NroDoc) as tipdoc ,convert (nvarchar,v.fecMov,103)as fecMov,cl.Ndoc as Doc_Cli ,
	case  when isnull( cl.RSocial,'')='' then cl.Nom +' '+cl.ApMat+' '+cl.ApPat else cl.RSocial end as cliente,
	''as Cd_Prod,'' as CodCo1_,''as Descrip,'' as Valor,'' as Cant, v.BIM_Neto as  IMP,(case when(isnull(convert(nvarchar,v.IGV),'')='') then 0.0 else v.IGV end ) as IGV,
	cast(case when Cd_Mda=@Cd_Mda then  v.Total  else case when isnull(@Cd_Mda,'')='01'then v.Total*v.CamMda else  v.Total/v.CamMda end    end  as decimal(16,2)) as Total ,
	'' as Cd_CC,'' as Cd_SC,'' as Cd_SS,      
	case when isnull(vd.Cd_Vdr,'')='' then 'No hay Descripcion' else vd.Cd_Vdr   end as cd_Vdr,
	case when isnull(vd.NDoc,'')='' then 'No hay Descripcion' else vd.NDoc   end as Ndoc_Vdr,
	v.Cd_Vta
from venta as v
	left join Vendedor2 as vd on v.RucE=vd.RucE and v.Cd_Vdr=vd.Cd_Vdr
	inner join Cliente2  as cl on v.RucE=cl.RucE and v.Cd_Clt= cl.Cd_Clt
where 
	v.RucE=@RucE and v.Eje=@Ejer and  /*v.Cd_Mda=@Cd_Mda  and*/
	case when isnull(@vendedor,'')<> '' then v.Cd_Vdr else '' end=isnull(@vendedor,'')  and
	case when isnull(@Area,'')<> '' then v.cd_Area else '' end=isnull(@Area,'')   and
	case when isnull(@Cd_Clt,'')<> '' then v.Cd_Clt else '' end=isnull(@Cd_Clt,'')   and
	v.FecMov between @FecIni and @FecFin + ' 23:59:29'
-----------------------------------------------------------------------------------------------------------------------
--------DETALLE--------------------------------------------------------------------------------------------------------

select 
	'' as Prdo,'' as tipdoc ,'' as fecMov,''as Doc_Cli ,''as cliente,
	case when ISNULL(vt.Cd_Prod,'')<>''then vt.Cd_Prod when ISNULL(vt.Cd_Srv,'')<>'' then vt.Cd_Srv else '--' end as Cd_Prod
	,isnull(p.CodCo1_,isnull(s.CodCo,'')) as CodCo1_,
	case when ISNULL(vt.Cd_Prod,'')<>''then p.Nombre1 when ISNULL(vt.Cd_Srv,'')<>'' then s.Nombre else '--' end as Descrip,
	vt.Valor,vt.Cant,vt.IMP,vt.IGV ,vt.total,
	vt.cd_Vta 
from ventadet as vt
	left join Producto2  as p on  vt.RucE=p.RucE and vt.Cd_Prod=p.Cd_Prod
	left join Servicio2 as s on  vt.RucE=s.RucE and vt.Cd_Srv=s.Cd_Srv
where 
	vt.RucE=@RucE and
	Cd_Vta in 
	(
	select v.Cd_Vta from Venta v
	where  v.RucE=@RucE and v.Eje=@Ejer and  /*v.Cd_Mda=@Cd_Mda  and*/
	case when isnull(@vendedor,'')<> '' then v.Cd_Vdr else '' end=isnull(@vendedor,'') and
	case when isnull(@Area,'')<> '' then v.cd_Area else '' end=isnull(@Area,'') and
	case when isnull(@Cd_Clt,'')<> '' then v.Cd_Clt else '' end=isnull(@Cd_Clt,'') and
	v.FecMov between @FecIni and @FecFin + ' 23:59:29'
)
--case when isnull(@vendedor,'')<> '' then vd.Cd_Vdr else '' end=isnull(@vendedor,'') 
--and vt.fecReg between @FecIni and @FecFin + ' 23:59:29'    
	
	if not exists (select top 1 * from VentaDet where RucE=@RucE)
		set @msj = 'No existe movimientos '
	print @msj
	
		
	 --   exec [dbo].[ReporteVentaDetallada] '20514402346','2012','02',null,null,'01/01/2012','31/03/2012',null
	--    exec [dbo].[ReporteVentaDetallada] '11111111111','2011',null,null, '01','2011/02/01' 
	 ------  codigo vendedor, 'VND0003'
	
	
	
	--select IGV,Total from Venta where RucE='20514402346' and Cd_Vta='VT00000014'
	
	
	--<<<<    16/03/12   CUTTI >>>
	
    
    

GO
