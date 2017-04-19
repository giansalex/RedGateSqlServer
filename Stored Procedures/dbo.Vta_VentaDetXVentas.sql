SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaDetXVentas]
@RucE nvarchar(11),
@Cd_Vta varchar(8000),
@msj varchar(100) output
as
declare @var varchar(8000)
set @var = '
select v.RegCtb,vd.Cd_Vta,vd.Nro_RegVdt as Item,case(isnull(vd.Cd_Prod,''0'')) 
when ''0'' then case(isnull(vd.Cd_Srv,''0'')) when ''0'' 
then null else vd.Cd_Srv end else vd.Cd_Prod end as Cd_Prod
	, vd.Descrip, vd.ID_UMP, um.DescripAlt, vd.PU, vd.Cant, vd.Valor, vd.DsctoP, vd.DsctoI, vd.IMP, vd.IGV, vd.Total
	, vd.Cd_CC, vd.Cd_SC, vd.Cd_SS, vd.Obs, vd.CA01, vd.CA02, vd.CA03, vd.CA04, vd.CA05, vd.CA06, vd.CA07, vd.CA08, vd.CA09, vd.CA10,vd.Cd_Alm,Alm.Nombre as Almacen
from 	VentaDet vd left join Prod_UM um on vd.RucE=um.RucE and vd.ID_UMP = um.ID_UMP and vd.Cd_Prod = um.Cd_Prod
	left join Almacen Alm on Alm.Cd_Alm=vd.Cd_Alm and Alm.RucE=vd.RucE
	left join Venta v on v.RucE = vd.RucE and v.Cd_Vta = vd.Cd_Vta
where	vd.RucE='''+@RucE+''' and vd.Cd_Vta in ('+@Cd_Vta+')'
print @var
exec(@var)
if @@rowcount = 0 set @msj = 'No hay item a consultar'
GO
