SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_CompraDetXCompras] 
@RucE nvarchar(11),
@Cd_Com varchar(8000),
@msj varchar(100) output
as
--set @RucE ='11111111111'
--set @Cd_Com = '''CM00000470'',''CM00000471'''

declare @var varchar(8000)
set @var = 
'select 	
c.RegCtb,cd.Cd_Com,cd.Item,case(isnull(cd.Cd_Prod,''0'')) 
when ''0'' then case(isnull(cd.Cd_Srv,''0'')) when ''0'' 
then null else cd.Cd_Srv end else cd.Cd_Prod end as Cd_Prod
	, cd.Descrip, cd.ID_UMP, um.DescripAlt, cd.PU, cd.Cant, cd.Valor, cd.DsctoP, cd.DsctoI, cd.IMP, cd.IGV, cd.Total
	, cd.Cd_CC, cd.Cd_SC, cd.Cd_SS, cd.Obs, cd.CA01, cd.CA02, cd.CA03, cd.CA04, cd.CA05, cd.CA06, cd.CA07, cd.CA08, cd.CA09, cd.CA10,cd.Cd_Alm,Alm.Nombre as Almacen
from 	CompraDet cd left join Prod_UM um on cd.RucE=um.RucE and cd.ID_UMP = um.ID_UMP and cd.Cd_Prod = um.Cd_Prod
	left join Almacen Alm on Alm.Cd_Alm=cd.Cd_Alm and Alm.RucE=cd.RucE
	left join Compra c on c.RucE = cd.RucE and c.Cd_Com = cd.Cd_Com
where	cd.RucE='''+@RucE+''' and cd.Cd_Com in ('+@Cd_Com+')'
print @var
exec(@var)
if @@rowcount = 0 set @msj = 'No hay item a consultar'

--exec Com_CompraDetXCompras '11111111111','CM00000018',null

--select* from compradet


GO
