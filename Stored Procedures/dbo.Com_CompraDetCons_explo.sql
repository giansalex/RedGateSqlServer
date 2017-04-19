SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_CompraDetCons_explo]
@RucE nvarchar(11),
@Cd_Com char(10),
@msj varchar(100) output
--with encryption
as
select 	cd.Item,case(isnull(cd.Cd_Prod,'0')) when '0' then case(isnull(cd.Cd_Srv,'0')) when '0' then null else cd.Cd_Srv end else cd.Cd_Prod end as Cd_Prod
	, cd.Descrip, cd.ID_UMP, um.DescripAlt, cd.PU, cd.Cant, cd.Valor, cd.DsctoP, cd.DsctoI, cd.IMP, cd.IGV, cd.Total
	, cd.Cd_CC, cd.Cd_SC, cd.Cd_SS, cd.Obs, cd.CA01, cd.CA02, cd.CA03, cd.CA04, cd.CA05, cd.CA06, cd.CA07, cd.CA08, cd.CA09, cd.CA10,cd.Cd_Alm,Alm.Nombre as Almacen,cd.Cd_Com,
	PUM.Factor
	, cd.UsuModf, cd.FecMdf
from 	CompraDet cd left join Prod_UM um on cd.RucE=um.RucE and cd.ID_UMP = um.ID_UMP and cd.Cd_Prod = um.Cd_Prod
	left join Almacen Alm on Alm.Cd_Alm=cd.Cd_Alm and Alm.RucE=cd.RucE
	left join Prod_UM PUM on PUM.RucE = cd.RucE and PUM.ID_UMP = cd.ID_UMP and PUM.Cd_Prod = cd.Cd_Prod
where	cd.RucE=@RucE and cd.Cd_Com=@Cd_Com
	print @msj

-- exec Com_CompraDetCons_explo '11111111111','CM00001096',''

--leyenda
--no se quien lo creo
-- cam 15/10/2012 mdf: agregue columnas usumodf y fecmdf
GO
