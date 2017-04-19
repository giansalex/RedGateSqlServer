SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ReporteVentaDetallada2]


@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
--@Prdo char(2),
@vendedor char(7),
@Area varchar(50),
@FecIni datetime,--nvarchar(10),
@FecFin datetime,   --nvarchar(10)
@RSocial varchar(150),
@TipoPago varchar(150),
@msj varchar(100) output
as
---------CABECERA-----------------------------------------------
SELECT     v.Prdo, v.NroSre + '-' + v.NroDoc AS tipdoc, CONVERT(nvarchar, v.FecMov, 103) AS fecMov, cl.NDoc AS Doc_Cli, CASE WHEN isnull(cl.RSocial, '') 
                      = '' THEN cl.Nom + ' ' + cl.ApMat + ' ' + cl.ApPat ELSE cl.RSocial END AS cliente, '' AS Cd_Prod, '' AS CodCo1_, '' AS Descrip, '' AS Valor, '' AS Cant, v.BIM_Neto AS IMP,
                       (CASE WHEN (isnull(CONVERT(nvarchar, v.IGV), '') = '') THEN 0.0 ELSE v.IGV END) AS IGV, 
                      CAST(CASE WHEN Cd_Mda = @Cd_Mda THEN v.Total ELSE CASE WHEN @Cd_Mda = '01' THEN v.Total * v.CamMda ELSE v.Total / v.CamMda END END AS decimal(16,
                       2)) AS Total, '' AS Cd_CC, '' AS Cd_SC, '' AS Cd_SS, CASE WHEN isnull(vd.Cd_Vdr, '') = '' THEN 'No hay Descripcion' ELSE vd.Cd_Vdr END AS cd_Vdr, 
                      CASE WHEN isnull(vd.NDoc, '') = '' THEN 'No hay Descripcion' ELSE vd.NDoc END AS Ndoc_Vdr, v.Cd_Vta
FROM         Venta AS v LEFT OUTER JOIN
                      Vendedor2 AS vd ON v.RucE = vd.RucE AND v.Cd_Vdr = vd.Cd_Vdr INNER JOIN
                      Cliente2 AS cl ON v.RucE = cl.RucE AND v.Cd_Clt = cl.Cd_Clt INNER JOIN
                      FormaPC ON v.Cd_FPC = FormaPC.Cd_FPC
where v.RucE=@RucE and v.Eje=@Ejer and  /*v.Cd_Mda=@Cd_Mda  and*/
case when isnull(@vendedor,'')<> '' then v.Cd_Vdr else '' end=isnull(@vendedor,'')  and
--modificar juan '26/06/2012' registre la razon social y tipo Pago  
case when isnull(@RSocial,'')<> '' then cl.RSocial else '' end=isnull(@RSocial,'')  and
case when isnull(@TipoPago,'')<> '' then FormaPC.Cd_FPC else '' end=isnull(@TipoPago,'')  and
--fin de la modificacion   
case when isnull(@Area,'')<> '' then v.cd_Area else '' end=isnull(@Area,'')   and
v.FecMov between @FecIni and @FecFin + ' 23:59:29'------------------------------------------------------------------
--------DETALLE--------------------------------------------------------------------------------------------------------

select '' as Prdo,'' as tipdoc ,'' as fecMov,''as Doc_Cli ,''as cliente,
case when ISNULL(vt.Cd_Prod,'')<>''then vt.Cd_Prod when ISNULL(vt.Cd_Srv,'')<>'' then vt.Cd_Srv else '--' end as Cd_Prod
,isnull(p.CodCo1_,isnull(s.CodCo,'')) as CodCo1_,
case when ISNULL(vt.Cd_Prod,'')<>''then p.Nombre1 when ISNULL(vt.Cd_Srv,'')<>'' then s.Nombre else '--' end as Descrip,
vt.Valor,vt.Cant,vt.IMP,vt.IGV ,vt.total,
vt.cd_Vta 
from ventadet as vt
left join Producto2  as p on  vt.RucE=p.RucE and vt.Cd_Prod=p.Cd_Prod
left join Servicio2 as s on  vt.RucE=s.RucE and vt.Cd_Srv=s.Cd_Srv
where vt.RucE=@RucE and
Cd_Vta in 
(
select v.Cd_Vta from Venta v
where v.RucE=@RucE and v.Eje=@Ejer and  /*v.Cd_Mda=@Cd_Mda  and*/
case when isnull(@vendedor,'')<> '' then v.Cd_Vdr else '' end=isnull(@vendedor,'')  and
case when isnull(@Area,'')<> '' then v.cd_Area else '' end=isnull(@Area,'')   and
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
